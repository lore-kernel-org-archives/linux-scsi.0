From: Jon Mason <mason@myri.com>
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Date: Thu, 1 Sep 2011 16:50:45 -0500
Message-ID: <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
References: <20110721181605.31672.36250.stgit@beardog.cce.hp.com>
	<1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20110901160724.GN9189@beardog.cce.hp.com>
	<1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com>
	<1314903038.3067.27.camel@dabdike>
	<20110901125938.7cb1da85@jbarnes-desktop>
	<20110901200349.GO9189@beardog.cce.hp.com>
	<20110901130930.5caec2d4@jbarnes-desktop>
	<20110901204419.GY8422@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636c927b0aab79604abe83c63
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20110901204419.GY8422@beardog.cce.hp.com>
Sender: linux-pci-owner@vger.kernel.org
To: scameron@beardog.cce.hp.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Dumazet <eric.dumazet@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com, linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

--001636c927b0aab79604abe83c63
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 1, 2011 at 3:44 PM,  <scameron@beardog.cce.hp.com> wrote:
> On Thu, Sep 01, 2011 at 01:09:30PM -0700, Jesse Barnes wrote:
>> On Thu, 1 Sep 2011 15:03:49 -0500
>> scameron@beardog.cce.hp.com wrote:
>>
>> > On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
>> > > On Thu, 01 Sep 2011 11:50:38 -0700
>> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>> > >
>> > > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
>> > > > > > OK I found the bad commit,I got lucky... I lost some files but=
 my
>> > > > > > machine was able to complete the bisection. CC involved people
>> > > > >
>> > > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI=
-E Max Payload Size on fabric
>> > > > >
>> > > > > Hi Eric,
>> > > > >
>> > > > > I guess it would be useful to see "lspci -vv" output with a "goo=
d" kernel
>> > > > > and with that bad patch applied. =A0Most likely we should see so=
me difference
>> > > > > somewhere in the MaxPayload fields in the PCI Express capability=
 of
>> > > > > some device.
>> > > > >
>> > > > > Either the RAID controller or something else lies, and puts a va=
lue
>> > > > > in the DevCap that it can't actually support, or else the patch =
is
>> > > > > buggy and puts something out of range in a DevCtl somewhere.
>> > > >
>> > > >
>> > > > While we investigate, I think the problems produced by the patch (=
data
>> > > > corruption) are serious enough to warrant reverting it, please Jes=
se.
>> > >
>> > > Hm I haven't been paying attention to the compromise thread; how sho=
uld
>> > > I share these changes? =A0Is master.kernel.org down indefinitely? =
=A0Is
>> > > there a new server at kernel.org I can use?
>> >
>> > I can't answer that question, but I would like a copy of your revert
>> > patch(es) to test (as a simple patch --reverse of the original commit =
on the 3.1-rc4
>> > tree didn't go in cleanly).
>>
>> Attached is the series. =A0Applies on top of my for-linus branch.
>
> Thanks. =A0I tried them out vs. 3.1-rc4, and they applied cleanly and
> make things work on my BL460g7.

I believe modifying the MRRS values is what is causing the issues.
Can you try the attached patch and verify that it also resolves the
issue?

Thanks,
Jon

> -- steve
>
>
>
>
>
>

--001636c927b0aab79604abe83c63
Content-Type: text/x-patch; charset=US-ASCII; name="mrrs_removal.patch"
Content-Disposition: attachment; filename="mrrs_removal.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gs29p3960

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGNpL3Byb2JlLmMgYi9kcml2ZXJzL3BjaS9wcm9iZS5jCmlu
ZGV4IDg0NzM3MjcuLmQ4OTZjNWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvcGNpL3Byb2JlLmMKKysr
IGIvZHJpdmVycy9wY2kvcHJvYmUuYwpAQCAtMTM5NCw0MSArMTM5NCw2IEBAIHN0YXRpYyB2b2lk
IHBjaWVfd3JpdGVfbXBzKHN0cnVjdCBwY2lfZGV2ICpkZXYsIGludCBtcHMpCiAJCWRldl9lcnIo
JmRldi0+ZGV2LCAiRmFpbGVkIGF0dGVtcHRpbmcgdG8gc2V0IHRoZSBNUFNcbiIpOwogfQogCi1z
dGF0aWMgdm9pZCBwY2llX3dyaXRlX21ycnMoc3RydWN0IHBjaV9kZXYgKmRldiwgaW50IG1wcykK
LXsKLQlpbnQgcmMsIG1ycnM7Ci0KLQlpZiAocGNpZV9idXNfY29uZmlnID09IFBDSUVfQlVTX1BF
UkZPUk1BTkNFKSB7Ci0JCWludCBkZXZfbXBzcyA9IDEyOCA8PCBkZXYtPnBjaWVfbXBzczsKLQot
CQkvKiBGb3IgTWF4IHBlcmZvcm1hbmNlLCB0aGUgTVJSUyBtdXN0IGJlIHNldCB0byB0aGUgbGFy
Z2VzdAotCQkgKiBzdXBwb3J0ZWQgdmFsdWUuICBIb3dldmVyLCBpdCBjYW5ub3QgYmUgY29uZmln
dXJlZCBsYXJnZXIKLQkJICogdGhhbiB0aGUgTVBTIHRoZSBkZXZpY2Ugb3IgdGhlIGJ1cyBjYW4g
c3VwcG9ydC4gIFRoaXMgYXNzdW1lcwotCQkgKiB0aGF0IHRoZSBsYXJnZXN0IE1SUlMgYXZhaWxh
YmxlIG9uIHRoZSBkZXZpY2UgY2Fubm90IGJlCi0JCSAqIHNtYWxsZXIgdGhhbiB0aGUgZGV2aWNl
IE1QU1MuCi0JCSAqLwotCQltcnJzID0gbXBzIDwgZGV2X21wc3MgPyBtcHMgOiBkZXZfbXBzczsK
LQl9IGVsc2UKLQkJLyogSW4gdGhlICJzYWZlIiBjYXNlLCBjb25maWd1cmUgdGhlIE1SUlMgZm9y
IGZhaXJuZXNzIG9uIHRoZQotCQkgKiBidXMgYnkgbWFraW5nIGFsbCBkZXZpY2VzIGhhdmUgdGhl
IHNhbWUgc2l6ZQotCQkgKi8KLQkJbXJycyA9IG1wczsKLQotCi0JLyogTVJSUyBpcyBhIFIvVyBy
ZWdpc3Rlci4gIEludmFsaWQgdmFsdWVzIGNhbiBiZSB3cml0dGVuLCBidXQgYQotCSAqIHN1YnNp
cXVlbnQgcmVhZCB3aWxsIHZlcmlmeSBpZiB0aGUgdmFsdWUgaXMgYWNjZXB0YWJsZSBvciBub3Qu
Ci0JICogSWYgdGhlIE1SUlMgdmFsdWUgcHJvdmlkZWQgaXMgbm90IGFjY2VwdGFibGUgKGUuZy4s
IHRvbyBsYXJnZSksCi0JICogc2hyaW5rIHRoZSB2YWx1ZSB1bnRpbCBpdCBpcyBhY2NlcHRhYmxl
IHRvIHRoZSBIVy4KLSAJICovCi0Jd2hpbGUgKG1ycnMgIT0gcGNpZV9nZXRfcmVhZHJxKGRldikg
JiYgbXJycyA+PSAxMjgpIHsKLQkJcmMgPSBwY2llX3NldF9yZWFkcnEoZGV2LCBtcnJzKTsKLQkJ
aWYgKHJjKQotCQkJZGV2X2VycigmZGV2LT5kZXYsICJGYWlsZWQgYXR0ZW1wdGluZyB0byBzZXQg
dGhlIE1SUlNcbiIpOwotCi0JCW1ycnMgLz0gMjsKLQl9Ci19Ci0KIHN0YXRpYyBpbnQgcGNpZV9i
dXNfY29uZmlndXJlX3NldChzdHJ1Y3QgcGNpX2RldiAqZGV2LCB2b2lkICpkYXRhKQogewogCWlu
dCBtcHMgPSAxMjggPDwgKih1OCAqKWRhdGE7CkBAIC0xNDQwLDcgKzE0MDUsNiBAQCBzdGF0aWMg
aW50IHBjaWVfYnVzX2NvbmZpZ3VyZV9zZXQoc3RydWN0IHBjaV9kZXYgKmRldiwgdm9pZCAqZGF0
YSkKIAkJIHBjaWVfZ2V0X21wcyhkZXYpLCAxMjg8PGRldi0+cGNpZV9tcHNzLCBwY2llX2dldF9y
ZWFkcnEoZGV2KSk7CiAKIAlwY2llX3dyaXRlX21wcyhkZXYsIG1wcyk7Ci0JcGNpZV93cml0ZV9t
cnJzKGRldiwgbXBzKTsKIAogCWRldl9pbmZvKCZkZXYtPmRldiwgIkRldiBNUFMgJWQgTVBTUyAl
ZCBNUlJTICVkXG4iLAogCQkgcGNpZV9nZXRfbXBzKGRldiksIDEyODw8ZGV2LT5wY2llX21wc3Ms
IHBjaWVfZ2V0X3JlYWRycShkZXYpKTsK
--001636c927b0aab79604abe83c63--
