From: <Stuart_Hayes@Dell.com>
Subject: RE: [PATCH 2.6.11] ide-scsi: map sg buffers in idescsi_input/output_buffers() to kernel virtual address
Date: Wed, 23 Mar 2005 17:46:45 -0600
Message-ID: <7A8F92187EF7A249BF847F1BF4903C04010EEA8B@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C53002.92902DFA"
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:822 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S262096AbVCWXqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 18:46:46 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org, Joshua_Giles@Dell.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C53002.92902DFA
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Jens Axboe wrote:
> On Thu, Mar 17 2005, Stuart_Hayes@Dell.com wrote:
>> Jens Axboe wrote:
>>> On Thu, Mar 17 2005, Jens Axboe wrote:
>>>> On Thu, Mar 17 2005, Stuart_Hayes@Dell.com wrote:
>>>>> Jens Axboe wrote:
>>>>>> On Wed, Mar 16 2005, Stuart_Hayes@Dell.com wrote:
>>>>>>> Jens Axboe wrote:
>>>>>>>> On Wed, Mar 16 2005, Stuart_Hayes@Dell.com wrote:
>>>>>>>>> Hayes, Stuart wrote:
>>>>>>>>>> This patch will map the sg buffers to kernel virtual memory
>>>>>>>>>> space in the functions idescsi_input_buffers() and
>>>>>>>>>> idescsi_output_buffers(). Without this patch, idescsi passes
>>>>>>>>>> a null pointer to atapi_input_bytes() and
>>>>>>>>>> atapi_output_bytes() when sg pages are in high memory (i686
>>>>>>>>>> architecture).=20
>>>>>>>>>>=20
>>>>>>>>>> I'm attaching as a file, too, as the text will certainly be
>>>>>>>>>> wrapped.
>>>>>>>>>>=20
>>>>>>>>>> (Sorry for the subject rename--I'm trying to use the correct
>>>>>>>>>> format for patch emails.)
>>>>>>>>>>=20
>>>>>>>>>> Thanks
>>>>>>>>>> Stuart
>>>>>>>>>=20
>>>>>>>>> And, while there's another high memory/kmap patch question on
>>>>>>>>> this list...=20
>>>>>>>>>=20
>>>>>>>>> Is there some reason nobody seems interested in this patch
>>>>>>>>> (except Jens--thanks for the help!)?  I'm kind of new to
>>>>>>>>> sending in patches, and I'm not sure if I'm just not waiting
>>>>>>>>> long enough, or if there is a problem with this patch...
>>>>>>>>>=20
>>>>>>>>> But really, we're getting a null pointer dereference oops when
>>>>>>>>> using ATAPI tape drives (with ide-scsi) without this patch...
>>>>>>>>=20
>>>>>>>> Sorry, that did seem to get dropped on the floor. Actually I'm
>>>>>>>> wondering why you are seeing highmem pages there in the first
>>>>>>>> place, it would be easier/better just to limit ide-scsi to
>>>>>>>> non-highmem pages. That would remove the need to add any work
>>>>>>>> arounds in the driver.
>>>>>>>=20
>>>>>>> I think we're seeing highmem pages in the sg list because that's
>>>>>>> where the user memory was when st_write() was called.
>>>>>>>=20
>>>>>>> The sg list is set up when st_write(), which calls
>>>>>>> setup_buffering(), which calls st_map_user_pages()... this just
>>>>>>> sets up the sg pages to point directly to the user memory.  So,
>>>>>>> by the time ide-scsi comes into the picture, the sg list is
>>>>>>> already set up to point to high memory pages.
>>>>>>>=20
>>>>>>> Are you suggesting that ide-scsi should change the dma_mask for
>>>>>>> the device so that st_map_user_pages() won't let sg pages point
>>>>>>> to high memory?  Or is there something else I'm missing?
>>>>>>=20
>>>>>> I think that is a bug, this effectively bypasses whatever
>>>>>> restrictions the scsi host adapter has said about memory limits.
>>>>>> It is a problem because the request doesn't come from the block
>>>>>> layer (which handles all of this).
>>>>>>=20
>>>>>> I would much prefer fixing that real issue!
>>>>>=20
>>>>> By "whatever restrictions the scsi host adapter has said about
>>>>> memory limits", are you referring to the dma_boundary or the
>>>>> dma_mask?  I'm don't know any other ways a host adapter can
>>>>> specify memory limits.
>>>>>=20
>>>>> I wasn't complete in my statement above,
>>>>> though--st_map_user_pages() does prevent the sg list from pointing
>>>>> to pages that are above the "max_pfn" for the device (it gets
>>>>> max_pfn from scsi_calculate_bounce_ limit()), and that appears to
>>>>> be working ok. But, even though max_pfn is 0xfffff (so that the
>>>>> maximum physical=20
>>>>> address of any sg page won't be over 4G (0xffffffff)), there are
>>>>> apparently high memory pages that are below physical address of 4G
>>>>> (0xffffffff), but are still considered high memory.
>>>>>=20
>>>>> So the entire first 4G of memory isn't low memory... for example,
>>>>> on my box, pfn 0xfbc3c, with physical address 0xfbc3c000, has the
>>>>> PG_highmem bit set in &(page)->flags.  Because of this, when
>>>>> ide-scsi needs to do PIO, it needs to do a kmap_atomic().
>>>>>=20
>>>>> Am I completely missing your point?
>>>>=20
>>>> Ok good, so st isn't broken at least. You are not missing my point,
>>>> but maybe you don't realize that highmem pages doesn't refer to any
>>>> specific address in memory - it refers to pages that don't have a
>>>> virtual mapping, so depending on the kernel config that can be
>>>> anywhere between ~900MB and 2GB (typicall). ide-scsi should just
>>>> use blk_max_low_pfn as the bounce limit, that will work all the
>>>> time.=20
>>>=20
>>> IOW, one way to solve this would be to add an shost->bounce_high
>>> flag and add something ala=20
>>>=20
>>>         if (shost->bounce_high)
>>>                 return BLK_BOUNCE_HIGH;
>>>=20
>>> to scsi_calculate_bounce_limit()
>>=20
>> Yes, I could easily implement that.  I had been trying to figure out
>> how to go about implementing what you said--I was looking at making
>> idescsi_attach change the dma_mask that scsi_calculate_bounce_limit()
>> currently looks at, but it wasn't looking very pretty.
>>=20
>> Unfortunately, I won't be able to do that fix with a DKMS driver on
>> an existing kernel... but that's not really relevant to this list.
>=20
> For your existing kernel fix, just use the one you sent last using
> kmap_atomic, it should work for you as well.=20
>=20
>> I'll try this out and send in a patch.
>>=20
>> Thanks!
>=20
> No problem, thanks for being persistent in getting this fixed :)

OK, sorry for the delay.  Here's the new patch to handle this as you
suggested, against the 2.6.11.5 kernel.  I have tested it, and it works.

Do I need to re-send this with a new subject line, since the patch
doesn't match the description in the subject line, or is it OK here?

I'll also attach as a file, though I'm optimistic that this one won't
be wrapped.

Thanks!
Stuart


Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>

diff -purN a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c	2005-03-15 19:09:08.000000000 -0500
+++ b/drivers/scsi/ide-scsi.c	2005-03-23 17:26:06.000000000 -0500
@@ -1048,6 +1048,7 @@ static int idescsi_attach(ide_drive_t *d
 		return 1;
=20
 	host->max_id =3D 1;
+	//host->bounce_high =3D 1;
=20
 #if IDESCSI_DEBUG_LOG
 	if (drive->id->last_lun)
diff -purN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2005-03-15 19:09:06.000000000 -0500
+++ b/drivers/scsi/scsi_lib.c	2005-03-23 17:26:04.000000000 -0500
@@ -1333,6 +1333,9 @@ u64 scsi_calculate_bounce_limit(struct S
=20
 	if (shost->unchecked_isa_dma)
 		return BLK_BOUNCE_ISA;
+
+	if (shost->bounce_high)
+		return BLK_BOUNCE_HIGH;
 	/*
 	 * Platforms with virtual-DMA translation
 	 * hardware have no practical limit.
diff -purN a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	2005-03-15 19:09:01.000000000 -0500
+++ b/include/scsi/scsi_host.h	2005-03-23 17:26:54.000000000 -0500
@@ -502,6 +502,12 @@ struct Scsi_Host {
 	unsigned reverse_ordering:1;
=20
 	/*
+	 * Host needs all high memory bounced (useful for ide-scsi,
+	 * so it doesn't have to kmap when doing PIO)
+	 */
+	unsigned bounce_high:1;
+
+	/*
 	 * Host has rejected a command because it was busy.
 	 */
 	unsigned int host_blocked;



------_=_NextPart_001_01C53002.92902DFA
Content-Type: application/octet-stream;
	name="ide-scsi-bouncehighmem-2.6.11.5.patch"
Content-Transfer-Encoding: base64
Content-Description: ide-scsi-bouncehighmem-2.6.11.5.patch
Content-Disposition: attachment;
	filename="ide-scsi-bouncehighmem-2.6.11.5.patch"

ZGlmZiAtcHVyTiBhL2RyaXZlcnMvc2NzaS9pZGUtc2NzaS5jIGIvZHJpdmVycy9zY3NpL2lkZS1z
Y3NpLmMKLS0tIGEvZHJpdmVycy9zY3NpL2lkZS1zY3NpLmMJMjAwNS0wMy0xNSAxOTowOTowOC4w
MDAwMDAwMDAgLTA1MDAKKysrIGIvZHJpdmVycy9zY3NpL2lkZS1zY3NpLmMJMjAwNS0wMy0yMyAx
NzoyNjowNi4wMDAwMDAwMDAgLTA1MDAKQEAgLTEwNDgsNiArMTA0OCw3IEBAIHN0YXRpYyBpbnQg
aWRlc2NzaV9hdHRhY2goaWRlX2RyaXZlX3QgKmQKIAkJcmV0dXJuIDE7CiAKIAlob3N0LT5tYXhf
aWQgPSAxOworCS8vaG9zdC0+Ym91bmNlX2hpZ2ggPSAxOwogCiAjaWYgSURFU0NTSV9ERUJVR19M
T0cKIAlpZiAoZHJpdmUtPmlkLT5sYXN0X2x1bikKZGlmZiAtcHVyTiBhL2RyaXZlcnMvc2NzaS9z
Y3NpX2xpYi5jIGIvZHJpdmVycy9zY3NpL3Njc2lfbGliLmMKLS0tIGEvZHJpdmVycy9zY3NpL3Nj
c2lfbGliLmMJMjAwNS0wMy0xNSAxOTowOTowNi4wMDAwMDAwMDAgLTA1MDAKKysrIGIvZHJpdmVy
cy9zY3NpL3Njc2lfbGliLmMJMjAwNS0wMy0yMyAxNzoyNjowNC4wMDAwMDAwMDAgLTA1MDAKQEAg
LTEzMzMsNiArMTMzMyw5IEBAIHU2NCBzY3NpX2NhbGN1bGF0ZV9ib3VuY2VfbGltaXQoc3RydWN0
IFMKIAogCWlmIChzaG9zdC0+dW5jaGVja2VkX2lzYV9kbWEpCiAJCXJldHVybiBCTEtfQk9VTkNF
X0lTQTsKKworCWlmIChzaG9zdC0+Ym91bmNlX2hpZ2gpCisJCXJldHVybiBCTEtfQk9VTkNFX0hJ
R0g7CiAJLyoKIAkgKiBQbGF0Zm9ybXMgd2l0aCB2aXJ0dWFsLURNQSB0cmFuc2xhdGlvbgogCSAq
IGhhcmR3YXJlIGhhdmUgbm8gcHJhY3RpY2FsIGxpbWl0LgpkaWZmIC1wdXJOIGEvaW5jbHVkZS9z
Y3NpL3Njc2lfaG9zdC5oIGIvaW5jbHVkZS9zY3NpL3Njc2lfaG9zdC5oCi0tLSBhL2luY2x1ZGUv
c2NzaS9zY3NpX2hvc3QuaAkyMDA1LTAzLTE1IDE5OjA5OjAxLjAwMDAwMDAwMCAtMDUwMAorKysg
Yi9pbmNsdWRlL3Njc2kvc2NzaV9ob3N0LmgJMjAwNS0wMy0yMyAxNzoyNjo1NC4wMDAwMDAwMDAg
LTA1MDAKQEAgLTUwMiw2ICs1MDIsMTIgQEAgc3RydWN0IFNjc2lfSG9zdCB7CiAJdW5zaWduZWQg
cmV2ZXJzZV9vcmRlcmluZzoxOwogCiAJLyoKKwkgKiBIb3N0IG5lZWRzIGFsbCBoaWdoIG1lbW9y
eSBib3VuY2VkICh1c2VmdWwgZm9yIGlkZS1zY3NpLAorCSAqIHNvIGl0IGRvZXNuJ3QgaGF2ZSB0
byBrbWFwIHdoZW4gZG9pbmcgUElPKQorCSAqLworCXVuc2lnbmVkIGJvdW5jZV9oaWdoOjE7CisK
KwkvKgogCSAqIEhvc3QgaGFzIHJlamVjdGVkIGEgY29tbWFuZCBiZWNhdXNlIGl0IHdhcyBidXN5
LgogCSAqLwogCXVuc2lnbmVkIGludCBob3N0X2Jsb2NrZWQ7Cg==

------_=_NextPart_001_01C53002.92902DFA--
