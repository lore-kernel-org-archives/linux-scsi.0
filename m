Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89E3C54FB9
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 07:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjKTHuf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 02:50:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjKTHue (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 02:50:34 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60987B7
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2023 23:50:30 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 02413210DF;
        Mon, 20 Nov 2023 07:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1700466628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V2eudvebb+7utA8Wkv8FE2IXQHheAlYTqCfPLx9CTn4=;
        b=r0Bv5X9xlyQz0NE/48IIcxTgkZ1xpQxSwdpyujs6uy0Gs8kSjzO92u1xPiYDsXMWFYAy+I
        buXJJopW9z3Hay4/saugzsIyIhmkn5Jt5mR19KbuUQcNzW2dHLr3DtFngoDzq7pt/NAVAE
        4kjYUiBn5uDZrsjFEcteHO9GTDASKFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1700466628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V2eudvebb+7utA8Wkv8FE2IXQHheAlYTqCfPLx9CTn4=;
        b=hSz+raFqahXuvq6lFSjWFGT3HkmOcngUgdbnDA18cz4d+QjGiBwMLZdmNw4V+5U8JFv21q
        fjsoJyC0O+fYx/CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 98BA4134AD;
        Mon, 20 Nov 2023 07:50:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7bn9I8QPW2XAOgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 20 Nov 2023 07:50:28 +0000
Content-Type: multipart/mixed; boundary="------------q0eVtnbWYVdRycE3BBezP00b"
Message-ID: <2d5071d6-daab-4585-823f-5f2e9dde8f79@suse.de>
Date:   Mon, 20 Nov 2023 08:50:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/16] fnic: allocate device reset command on the fly
Content-Language: en-US
To:     "Karan Tilak Kumar (kartilak)" <kartilak@cisco.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Dhanraj Jhawar (djhawar)" <djhawar@cisco.com>,
        "Gian Carlo Boffa (gcboffa)" <gcboffa@cisco.com>,
        "Masa Kai (mkai2)" <mkai2@cisco.com>,
        "Satish Kharat (satishkh)" <satishkh@cisco.com>,
        "Arulprabhu Ponnusamy (arulponn)" <arulponn@cisco.com>,
        "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>
References: <20231023091507.120828-1-hare@suse.de>
 <20231023091507.120828-14-hare@suse.de> <20231024065427.GD9847@lst.de>
 <SJ0PR11MB589682551110734A017D19C3C3AAA@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58960463A1A9D634BE8D2A62C3B2A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <a5df8cc9-34c4-4448-817f-0f61f4a493de@suse.de>
 <SJ0PR11MB5896E596C922936ABDDE0567C3B0A@SJ0PR11MB5896.namprd11.prod.outlook.com>
 <SJ0PR11MB58961DC466F1FC2DAD8825F6C3B7A@SJ0PR11MB5896.namprd11.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <SJ0PR11MB58961DC466F1FC2DAD8825F6C3B7A@SJ0PR11MB5896.namprd11.prod.outlook.com>
Authentication-Results: smtp-out1.suse.de;
        none
X-Spamd-Result: default: False [4.50 / 50.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         XM_UA_NO_VERSION(0.01)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         MIME_GOOD(-0.10)[multipart/mixed,text/plain,text/x-patch];
         HAS_ATTACHMENT(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         MIME_BASE64_TEXT_BOGUS(1.00)[];
         NEURAL_SPAM_SHORT(2.99)[0.998];
         DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
         MIME_BASE64_TEXT(0.10)[];
         RCPT_COUNT_SEVEN(0.00)[11];
         NEURAL_SPAM_LONG(3.50)[1.000];
         FUZZY_BLOCKED(0.00)[rspamd.com];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:+];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[];
         MID_RHS_MATCH_FROM(0.00)[]
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------q0eVtnbWYVdRycE3BBezP00b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/18/23 00:31, Karan Tilak Kumar (kartilak) wrote:
> On Wednesday, November 15, 2023 4:22 PM, Karan Tilak Kumar (kartilak) wrote:
>>
>> On Tuesday, November 14, 2023 12:02 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>> I integrated your patch set using "b4 shazam" and built all the changes to do some dev testing.
>>>> I instrumented the code to do the following:
>>>>
>>>> - After one million IOs, drop one IO response.
>>>> - This will trigger an abort. Drop that abort response.
>>>> - This will trigger a device reset. I'm seeing that the tag here is 0xFFFFFFFF (SCSI_NO_TAG).
>>>>
>>>> This tag fails the out-of-range tag check and escalates to host reset.
>>>> I've been able to repro this three times with the same result.
>>>>
>>>> The expectation with this test case is that the device reset should go through successfully without escalating to host reset.
>>>>
>>> Thanks for the report.
>>> Certainly not what was intended with the patch. Can you try with this patch on top:
>>
>> I applied this patch on top of the previous one and performed the unit tests that I had mentioned before.
>>
>>>
>>> (The first hunk is actually a bugfix, and will be included with the next submission anyway.) Please enable fnic debug during testing and send me the logs.
>>> It _might_ be that this is actually by design, as we will be failing if all tags are busy (ie if the error is EWOULDBLOCK).
>>> But if we get EAGAIN it means that the queue is blocked and we'll need to investigate.
>>
>> There were two attempts at reproduction. One of them resulted in a crash. I have enabled fnic debug and captured the log.
>> I've pasted the excerpt here for reference.
>>
>> Repro 1:
>>
[ .. ]
>>
>> =============
>> Repro 2:
>>
[ .. ]
>>
>>
>> Regards,
>> Karan
>>
> 
> Repro 3:
> 
> Nov 17 15:27:00 rhel-c4s5 kernel: fnic<7>: UT: fnic_fcpio_icmnd_cmpl_handler: 847: tag: 0x52 sc: 00000000fab117f4 CDB Opcode: 0x28 Dropping icmnd completion
> Nov 17 15:27:30 rhel-c4s5 kernel: scsi host7: Abort Cmd called FCID 0x5205f2, LUN 0x2 TAG 52 flags 3
> Nov 17 15:27:30 rhel-c4s5 kernel: scsi host7: CBD Opcode: 28 Abort issued time: 30067 msec
> Nov 17 15:27:30 rhel-c4s5 kernel: scsi host7: fnic<7>: UT: fnic_fcpio_itmf_cmpl_handler: 1113: tag: 0x52 sc: 00 status: FCPIO_IO_NOT_FOUND Dropping abort completion
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Returning from abort cmd type 2 FAILED
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Device reset called FCID 0x5205f2, LUN 0x2 sc: 00000000fab117f4
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Device reset allocation failed with -11
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_reset called
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0xfffffc
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x52061b
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205f2
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205cb
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205ca
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: update_mac 00:25:b5:cc:aa:00
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Issued fw reset
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: set port_id 0 fp 0000000000000000
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Returning from fnic reset SUCCESS
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0xfffffc
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_cleanup_io: tag:0x52 : sc:0x00000000fab117f4 duration = 52450 DID_TRANSPORT_DISRUPTED
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: Calling done for IO not issued to fw: tag:0x52 sc:0x00000000fab117f4
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: reset cmpl success
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x52061b
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205f2
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205cb
> Nov 17 15:27:52 rhel-c4s5 kernel: scsi host7: fnic_rport_exch_reset called portid 0x5205ca
> Nov 17 15:27:54 rhel-c4s5 kernel: host7: Assigned Port ID 0d0880
> Nov 17 15:27:54 rhel-c4s5 kernel: scsi host7: set port_id d0880 fp 0000000067a66565
> Nov 17 15:27:54 rhel-c4s5 kernel: scsi host7: update_mac 0e:fc:00:0d:08:80
> Nov 17 15:27:54 rhel-c4s5 kernel: scsi host7: FLOGI reg issued fcid d0880 map 0 dest 8c:60:4f:95:ea:a4
> Nov 17 15:27:54 rhel-c4s5 kernel: scsi host7: flog reg succeeded
> Nov 17 15:28:06 rhel-c4s5 kernel: sd 7:0:3:2: Power-on or device reset occurred
> 
Seems that 'blk_queue_enter()' called from scsi_alloc_request() is 
failing, presumably as the queue is frozen/quiesced.
Can you try with the attached patch instead of the previous debug patch?

On, and incidentally: there's an unlock missing:

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 0278c4a207f3..47bcc6bd7376 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2233,8 +2233,10 @@ int fnic_device_reset(struct scsi_device *sdev)
         io_lock = fnic_io_lock_hash(fnic, sc);
         spin_lock_irqsave(io_lock, flags);
         io_req = fnic_priv(sc)->io_req;
-       if (io_req)
+       if (io_req) {
+               spin_unlock_irqrestore(io_lock, flags);
                 goto fnic_device_reset_end;
+       }

         io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
         if (!io_req) {

Maybe fold it in with your patchset (if it's not already merged).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

--------------q0eVtnbWYVdRycE3BBezP00b
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-fnic-debug-device-reset-command-allocation-failures.patch"
Content-Disposition: attachment;
 filename*0="0001-fnic-debug-device-reset-command-allocation-failures.pat";
 filename*1="ch"
Content-Transfer-Encoding: base64

RnJvbSBmN2ViYTczZjA2NTRlYmQyMDYwYjkyYWIwOGM5NDU4MjQzYTljOTE0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBIYW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4K
RGF0ZTogTW9uLCAyMCBOb3YgMjAyMyAwODo0MToxNiArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IGZuaWM6IGRlYnVnIGRldmljZSByZXNldCBjb21tYW5kIGFsbG9jYXRpb24gZmFpbHVyZXMK
CkFkZCBjb2RlIHRvIGRlYnVnIHdoeSBkZXZpY2UgcmVzZXQgY29tbWFuZCBhbGxvY2F0aW9u
IGZhaWxzLgoKU2lnbmVkLW9mZi1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+
Ci0tLQogZHJpdmVycy9zY3NpL2ZuaWMvZm5pY19zY3NpLmMgfCA5ICsrKysrKy0tLQogMSBm
aWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYyBiL2RyaXZlcnMvc2NzaS9mbmlj
L2ZuaWNfc2NzaS5jCmluZGV4IDg5MDljZjA5Y2Y5ZS4uMDI3OGM0YTIwN2YzIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvZm5pYy9mbmljX3Njc2kuYworKysgYi9kcml2ZXJzL3Njc2kv
Zm5pYy9mbmljX3Njc2kuYwpAQCAtMjIwOSw4ICsyMjA5LDggQEAgaW50IGZuaWNfZGV2aWNl
X3Jlc2V0KHN0cnVjdCBzY3NpX2RldmljZSAqc2RldikKIAl9CiAKIAlyZXEgPSBzY3NpX2Fs
bG9jX3JlcXVlc3Qoc2Rldi0+cmVxdWVzdF9xdWV1ZSwgUkVRX09QX0RSVl9JTiwKLQkJCQkg
QkxLX01RX1JFUV9OT1dBSVQpOwotCWlmICghcmVxKSB7CisJCQkJIEJMS19NUV9SRVFfTk9X
QUlUIHwgQkxLX01RX1JFUV9QTSk7CisJaWYgKElTX0VSUihyZXEpKSB7CiAJCS8qCiAJCSAq
IFJlcXVlc3QgYWxsb2NhdGlvbiBtaWdodCBmYWlsLCBpbmRpY2F0aW5nIHRoYXQKIAkJICog
YWxsIHRhZ3MgYXJlIGJ1c3kuCkBAIC0yMjIxLDcgKzIyMjEsMTAgQEAgaW50IGZuaWNfZGV2
aWNlX3Jlc2V0KHN0cnVjdCBzY3NpX2RldmljZSAqc2RldikKIAkJICogdG8gaG9zdCByZXNl
dCBhbnl3YXkuCiAJCSAqLwogCQlGTklDX1NDU0lfREJHKEtFUk5fRVJSLCBmbmljLT5scG9y
dC0+aG9zdCwKLQkJCSAgICAgICJEZXZpY2UgcmVzZXQgYWxsb2NhdGlvbiBmYWlsZWQsIGFs
bCB0YWdzIGJ1c3lcbiIpOworCQkJICAgICAgIkRldmljZSByZXNldCBhbGxvY2F0aW9uIGZh
aWxlZCAoZXJyb3IgJWxkJXMlcylcbiIsCisJCQkgICAgICBQVFJfRVJSKHJlcSksCisJCQkg
ICAgICBzZGV2LT5yZXF1ZXN0X3F1ZXVlLT5tcV9mcmVlemVfZGVwdGggPyAiLGZyb3plbiIg
OiAiIiwKKwkJCSAgICAgIHNkZXYtPnF1aWVzY2VkX2J5ID8gIixxdWllc2NlZCIgOiAiIik7
CiAJCXJldHVybiByZXQ7CiAJfQogCXNjID0gYmxrX21xX3JxX3RvX3BkdShyZXEpOwotLSAK
Mi4zNS4zCgo=

--------------q0eVtnbWYVdRycE3BBezP00b--
