Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 730D1C7EE2C
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 12:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244880AbjHYMgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 08:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244890AbjHYMft (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 08:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0342682;
        Fri, 25 Aug 2023 05:35:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1C876146E;
        Fri, 25 Aug 2023 12:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CB0C433C7;
        Fri, 25 Aug 2023 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692965993;
        bh=lo8kdtKnIBMK0RBmDSkBDge4uqBrL+/NmJx/VM6oMgQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BQ3ePLkd0q0asul4eHgyUaLuxWJwbBg47Whisv0UFq2rYlyaeDBvYeM0OTcCe1uuT
         yP58zv/e9glkXCoFgqAgRvGTMJHJstat1qOxAS95pYmCLxyw2xAxfsR/TYqftsC2K0
         d8hQpmdwHmPBJCAm7Hmr5J5niJfqu0bBPRZ6fr4SKScH+xCx8EL5MRLSLzSl2vO2sN
         /hdadvh2FflG1lAqJLpiyTY8UpO0go+7fRClx9SD4fOfaTNTVEtpczuG0XZp6zXv/W
         cq8scKduFdOnHacFZ7CPzeBI73IPP/CgWyn3VQzC2W+YFvwDyHPKMAtw0UcnO8zsmm
         bREL5CfJLy1WA==
Content-Type: multipart/mixed; boundary="------------bF6QaiUtzo0gJ30Vc16x27lO"
Message-ID: <ef45e164-dccb-c149-b85d-ae4e812935b4@kernel.org>
Date:   Fri, 25 Aug 2023 21:19:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ata,scsi: do not issue START STOP UNIT on resume
Content-Language: en-US
To:     Rodrigo Vivi <rodrigo.vivi@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        TW <dalzot@gmail.com>, regressions@lists.linux.dev,
        Bart Van Assche <bvanassche@acm.org>
References: <20230731003956.572414-1-dlemoal@kernel.org>
 <ZOehTysWO+U3mVvK@rdvivi-mobl4>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZOehTysWO+U3mVvK@rdvivi-mobl4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------bF6QaiUtzo0gJ30Vc16x27lO
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/25/23 03:28, Rodrigo Vivi wrote:
> On Mon, Jul 31, 2023 at 09:39:56AM +0900, Damien Le Moal wrote:
>> During system resume, ata_port_pm_resume() triggers ata EH to
>> 1) Resume the controller
>> 2) Reset and rescan the ports
>> 3) Revalidate devices
>> This EH execution is started asynchronously from ata_port_pm_resume(),
>> which means that when sd_resume() is executed, none or only part of the
>> above processing may have been executed. However, sd_resume() issues a
>> START STOP UNIT to wake up the drive from sleep mode. This command is
>> translated to ATA with ata_scsi_start_stop_xlat() and issued to the
>> device. However, depending on the state of execution of the EH process
>> and revalidation triggerred by ata_port_pm_resume(), two things may
>> happen:
>> 1) The START STOP UNIT fails if it is received before the controller has
>>    been reenabled at the beginning of the EH execution. This is visible
>>    with error messages like:
>>
>> ata10.00: device reported invalid CHS sector 0
>> sd 9:0:0:0: [sdc] Start/Stop Unit failed: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
>> sd 9:0:0:0: [sdc] Sense Key : Illegal Request [current]
>> sd 9:0:0:0: [sdc] Add. Sense: Unaligned write command
>> sd 9:0:0:0: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x90 returns -5
>> sd 9:0:0:0: PM: failed to resume async: error -5
>>
>> 2) The START STOP UNIT command is received while the EH process is
>>    on-going, which mean that it is stopped and must wait for its
>>    completion, at which point the command is rather useless as the drive
>>    is already fully spun up already. This case results also in a
>>    significant delay in sd_resume() which is observable by users as
>>    the entire system resume completion is delayed.
>>
>> Given that ATA devices will be woken up by libata activity on resume,
>> sd_resume() has no need to issue a START STOP UNIT command, which solves
>> the above mentioned problems. Do not issue this command by introducing
>> the new scsi_device flag no_start_on_resume and setting this flag to 1
>> in ata_scsi_dev_config(). sd_resume() is modified to issue a START STOP
>> UNIT command only if this flag is not set.
> 
> Hi Damien,
> 
> Last week I noticed that a basic test in our validation started failing,
> then I noticed that it was subsequent quick suspend and autoresume using
> rtcwake that was problematic.
> 
> I couldn't collect any specific log that was pointing to some useful direction.
> After a painful bisect I got to this patch. After reverting in from the
> top of our tree, the tests are back to life.
> 
> The issue was that the subsequent quick suspend-resume (sometimes the
> second, sometimes third or even sixth) was simply hanging the machine
> in different points at Suspend.
> 
> So, maybe we have some kind of disks/configuration out there where this
> start upon resume is needed? Maybe it is just a matter of timming to
> ensure some firmware underneath is up and back to life?
> 
> Well, please let me know the best way to report this issue to you and what
> kind of logs I should get.
> 
> Meanwhile if this ends up blocking our CI we can keep a revert in a
> topic branch for CI.

Can you try adding the patch attached to this email ?
Thanks.

-- 
Damien Le Moal
Western Digital Research

--------------bF6QaiUtzo0gJ30Vc16x27lO
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-ata-libata-scsi-link-ata-port-and-scsi-device.patch"
Content-Disposition: attachment;
 filename="0001-ata-libata-scsi-link-ata-port-and-scsi-device.patch"
Content-Transfer-Encoding: base64

RnJvbSAyMGI2MzY0OTRmOWM5OGJiY2E1MGQ2YjJmYjEyMzVmNDc0NzZjZGI0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEYW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwu
b3JnPgpEYXRlOiBGcmksIDI1IEF1ZyAyMDIzIDE1OjQxOjE0ICswOTAwClN1YmplY3Q6IFtQ
QVRDSF0gYXRhOiBsaWJhdGEtc2NzaTogbGluayBhdGEgcG9ydCBhbmQgc2NzaSBkZXZpY2UK
ClRoZXJlIGlzIG5vIGRpcmVjdCBhbmNlc3RyeSBiZXR3ZWVuIGFuIGF0YV9kZXZpY2UgYW5k
IGl0cyBzY3NpIGRldmljZSwKd2hpY2ggcHJldmVudHMgdGhlIHBvd2VyIG1hbmFnZW1lbnQg
Y29kZSBmcm9tIGNvcnJlY3RseSBvcmRlcmluZyBzdXNwZW5kCmFuZCByZXN1bWUgb3BlcmF0
aW9ucywgd2hpY2ggcmVxdWlyZXMgYWRkaXRpb25hbCBjb2RlIHRvIGJlIGhhbmRsZWQKY29y
cmVjdGx5LiBDcmVhdGUgc3VjaCBhbmNlc3RyeSB0byBhbGxvdyBzaW1wbGlmeWluZyB0aGUg
Y29kZS4KClRoZSBwYXJlbnQtY2hpbGQgKHN1cHBsaWVyLWNvbnN1bWVyKSByZWxhdGlvbnNo
aXAgaXMgZXN0YWJsaXNoZWQgYmV0d2Vlbgp0aGUgYXRhX3BvcnQgKHBhcmVudCkgYW5kIHRo
ZSBzY3NpIGRldmljZSAoY2hpbGQpIHdpdGgKZGV2aWNlX2FkZF9saW5rKCkuIFRoZSBwYXJl
bnQgdXNlZCBpcyBub3QgdGhlIGF0YV9kZXZpY2UgYXMgdGhlIFBNCm9wZXJhdGlvbnMgYXJl
IGRlZmluZWQgcGVyIHBvcnQgYW5kIGRldmljZXMgc3RhdHVzIGNvbnRyb2xsZWQgZnJvbSB0
aGVzZQpwb3J0IG9wZXJhdGlvbnMuCgpUaGUgZGV2aWNlIGxpbmsgaXMgZXN0YWJsaXNoZWQg
d2l0aCB0aGUgbmV3IGZ1bmN0aW9uCmF0YV9zY3NpX2Rldl9hbGxvYygpLiBUaGlzIGZ1bmN0
aW9uIGlzIHVzZWQgdG8gZGVmaW5lIHRoZSAtPnNsYXZlX2FsbG9jCmNhbGxiYWNrIG9mIHRo
ZSBzY3NpIGhvc3QgdGVtcGxhdGUgb2YgYWxsIGRyaXZlcnMuCgpTaWduZWQtb2ZmLWJ5OiBE
YW1pZW4gTGUgTW9hbCA8ZGxlbW9hbEBrZXJuZWwub3JnPgotLS0KIGRyaXZlcnMvYXRhL2xp
YmF0YS1zY3NpLmMgfCA0NiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0t
LS0KIGRyaXZlcnMvYXRhL2xpYmF0YS5oICAgICAgfCAgMSArCiBkcml2ZXJzL2F0YS9wYXRh
X21hY2lvLmMgIHwgIDEgKwogZHJpdmVycy9hdGEvc2F0YV9tdi5jICAgICB8ICAxICsKIGRy
aXZlcnMvYXRhL3NhdGFfbnYuYyAgICAgfCAgMiArKwogZHJpdmVycy9hdGEvc2F0YV9zaWwy
NC5jICB8ICAxICsKIGluY2x1ZGUvbGludXgvbGliYXRhLmggICAgfCAgMyArKysKIDcgZmls
ZXMgY2hhbmdlZCwgNTAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL2F0YS9saWJhdGEtc2NzaS5jIGIvZHJpdmVycy9hdGEvbGliYXRhLXNj
c2kuYwppbmRleCBjNmVjZTMyZGU4ZTMuLmFiNTcyY2M5YjNmOSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hdGEvbGliYXRhLXNjc2kuYworKysgYi9kcml2ZXJzL2F0YS9saWJhdGEtc2NzaS5j
CkBAIC0xMTM5LDYgKzExMzksNDUgQEAgaW50IGF0YV9zY3NpX2Rldl9jb25maWcoc3RydWN0
IHNjc2lfZGV2aWNlICpzZGV2LCBzdHJ1Y3QgYXRhX2RldmljZSAqZGV2KQogCXJldHVybiAw
OwogfQogCitpbnQgYXRhX3Njc2lfZGV2X2FsbG9jKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rl
diwgc3RydWN0IGF0YV9wb3J0ICphcCkKK3sKKwlzdHJ1Y3QgZGV2aWNlX2xpbmsgKmxpbms7
CisKKwlhdGFfc2NzaV9zZGV2X2NvbmZpZyhzZGV2KTsKKworCS8qCisJICogQ3JlYXRlIGEg
bGluayBmcm9tIHRoZSBhdGFfcG9ydCBkZXZpY2UgdG8gdGhlIHNjc2kgZGV2aWNlIHRvIGVu
c3VyZQorCSAqIHRoYXQgUE0gZG9lcyBzdXNwZW5kL3Jlc3VtZSBpbiB0aGUgY29ycmVjdCBv
cmRlcjogdGhlIHNjc2kgZGV2aWNlIGlzCisJICogY29uc3VtZXIgKGNoaWxkKSBhbmQgdGhl
IGF0YSBwb3J0IHRoZSBzdXBwbGllciAocGFyZW50KS4KKwkgKi8KKwlsaW5rID0gZGV2aWNl
X2xpbmtfYWRkKCZzZGV2LT5zZGV2X2dlbmRldiwgJmFwLT50ZGV2LAorCQkJICAgICAgIERM
X0ZMQUdfUE1fUlVOVElNRSB8IERMX0ZMQUdfUlBNX0FDVElWRSk7CisJaWYgKCFsaW5rKSB7
CisJCWF0YV9wb3J0X2VycihhcCwgIkZhaWxlZCB0byBjcmVhdGUgbGluayB0byBzY3NpIGRl
dmljZSAlc1xuIiwKKwkJCSAgICAgZGV2X25hbWUoJnNkZXYtPnNkZXZfZ2VuZGV2KSk7CisJ
CXJldHVybiAtRU5PREVWOworCX0KKworCXJldHVybiAwOworfQorCisvKioKKyAqCWF0YV9z
Y3NpX3NsYXZlX2FsbG9jIC0gRWFybHkgc2V0dXAgb2YgU0NTSSBkZXZpY2UKKyAqCUBzZGV2
OiBTQ1NJIGRldmljZSB0byBleGFtaW5lCisgKgorICoJVGhpcyBpcyBjYWxsZWQgZnJvbSBz
Y3NpX2FsbG9jX3NkZXYoKSB3aGVuIHRoZSBzY3NpIGRldmljZQorICoJYXNzb2NpYXRlZCB3
aXRoIGFuIEFUQSBkZXZpY2UgaXMgc2Nhbm5lZCBvbiBhIHBvcnQuCisgKgorICoJTE9DS0lO
RzoKKyAqCURlZmluZWQgYnkgU0NTSSBsYXllci4gIFdlIGRvbid0IHJlYWxseSBjYXJlLgor
ICovCisKK2ludCBhdGFfc2NzaV9zbGF2ZV9hbGxvYyhzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNk
ZXYpCit7CisJcmV0dXJuIGF0YV9zY3NpX2Rldl9hbGxvYyhzZGV2LCBhdGFfc2hvc3RfdG9f
cG9ydChzZGV2LT5ob3N0KSk7Cit9CitFWFBPUlRfU1lNQk9MX0dQTChhdGFfc2NzaV9zbGF2
ZV9hbGxvYyk7CisKIC8qKgogICoJYXRhX3Njc2lfc2xhdmVfY29uZmlnIC0gU2V0IFNDU0kg
ZGV2aWNlIGF0dHJpYnV0ZXMKICAqCUBzZGV2OiBTQ1NJIGRldmljZSB0byBleGFtaW5lCkBA
IC0xMTU1LDE0ICsxMTk0LDExIEBAIGludCBhdGFfc2NzaV9zbGF2ZV9jb25maWcoc3RydWN0
IHNjc2lfZGV2aWNlICpzZGV2KQogewogCXN0cnVjdCBhdGFfcG9ydCAqYXAgPSBhdGFfc2hv
c3RfdG9fcG9ydChzZGV2LT5ob3N0KTsKIAlzdHJ1Y3QgYXRhX2RldmljZSAqZGV2ID0gX19h
dGFfc2NzaV9maW5kX2RldihhcCwgc2Rldik7Ci0JaW50IHJjID0gMDsKLQotCWF0YV9zY3Np
X3NkZXZfY29uZmlnKHNkZXYpOwogCiAJaWYgKGRldikKLQkJcmMgPSBhdGFfc2NzaV9kZXZf
Y29uZmlnKHNkZXYsIGRldik7CisJCXJldHVybiBhdGFfc2NzaV9kZXZfY29uZmlnKHNkZXYs
IGRldik7CiAKLQlyZXR1cm4gcmM7CisJcmV0dXJuIDA7CiB9CiBFWFBPUlRfU1lNQk9MX0dQ
TChhdGFfc2NzaV9zbGF2ZV9jb25maWcpOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9s
aWJhdGEuaCBiL2RyaXZlcnMvYXRhL2xpYmF0YS5oCmluZGV4IGNmOTkzODg1ZDJiMi4uYzQ1
Y2FjMmEzNjMxIDEwMDY0NAotLS0gYS9kcml2ZXJzL2F0YS9saWJhdGEuaAorKysgYi9kcml2
ZXJzL2F0YS9saWJhdGEuaApAQCAtMTEzLDYgKzExMyw3IEBAIGV4dGVybiBzdHJ1Y3QgYXRh
X2RldmljZSAqYXRhX3Njc2lfZmluZF9kZXYoc3RydWN0IGF0YV9wb3J0ICphcCwKIGV4dGVy
biBpbnQgYXRhX3Njc2lfYWRkX2hvc3RzKHN0cnVjdCBhdGFfaG9zdCAqaG9zdCwKIAkJCSAg
ICAgIGNvbnN0IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgKnNodCk7CiBleHRlcm4gdm9p
ZCBhdGFfc2NzaV9zY2FuX2hvc3Qoc3RydWN0IGF0YV9wb3J0ICphcCwgaW50IHN5bmMpOwor
ZXh0ZXJuIGludCBhdGFfc2NzaV9kZXZfYWxsb2Moc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2
LCBzdHJ1Y3QgYXRhX3BvcnQgKmFwKTsKIGV4dGVybiBpbnQgYXRhX3Njc2lfb2ZmbGluZV9k
ZXYoc3RydWN0IGF0YV9kZXZpY2UgKmRldik7CiBleHRlcm4gYm9vbCBhdGFfc2NzaV9zZW5z
ZV9pc192YWxpZCh1OCBzaywgdTggYXNjLCB1OCBhc2NxKTsKIGV4dGVybiB2b2lkIGF0YV9z
Y3NpX3NldF9zZW5zZShzdHJ1Y3QgYXRhX2RldmljZSAqZGV2LApkaWZmIC0tZ2l0IGEvZHJp
dmVycy9hdGEvcGF0YV9tYWNpby5jIGIvZHJpdmVycy9hdGEvcGF0YV9tYWNpby5jCmluZGV4
IDE3ZjZjY2VlNTNjNy4uMzI5NjhiNGNmOGU0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2F0YS9w
YXRhX21hY2lvLmMKKysrIGIvZHJpdmVycy9hdGEvcGF0YV9tYWNpby5jCkBAIC05MTgsNiAr
OTE4LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgcGF0YV9t
YWNpb19zaHQgPSB7CiAJICogdXNlIDY0SyBtaW51cyAyNTYKIAkgKi8KIAkubWF4X3NlZ21l
bnRfc2l6ZQk9IE1BWF9EQkRNQV9TRUcsCisJLnNsYXZlX2FsbG9jCQk9IGF0YV9zY3NpX3Ns
YXZlX2FsbG9jLAogCS5zbGF2ZV9jb25maWd1cmUJPSBwYXRhX21hY2lvX3NsYXZlX2NvbmZp
ZywKIAkuc2Rldl9ncm91cHMJCT0gYXRhX2NvbW1vbl9zZGV2X2dyb3VwcywKIAkuY2FuX3F1
ZXVlCQk9IEFUQV9ERUZfUVVFVUUsCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9zYXRhX212
LmMgYi9kcml2ZXJzL2F0YS9zYXRhX212LmMKaW5kZXggZDQwNGU2MzFkMTUyLi4zN2EwYmJh
YTgzNDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYXRhL3NhdGFfbXYuYworKysgYi9kcml2ZXJz
L2F0YS9zYXRhX212LmMKQEAgLTY3Myw2ICs2NzMsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IHNjc2lfaG9zdF90ZW1wbGF0ZSBtdjZfc2h0ID0gewogCS5zZGV2X2dyb3VwcwkJPSBhdGFf
bmNxX3NkZXZfZ3JvdXBzLAogCS5jaGFuZ2VfcXVldWVfZGVwdGgJPSBhdGFfc2NzaV9jaGFu
Z2VfcXVldWVfZGVwdGgsCiAJLnRhZ19hbGxvY19wb2xpY3kJPSBCTEtfVEFHX0FMTE9DX1JS
LAorCS5zbGF2ZV9hbGxvYwkJPSBhdGFfc2NzaV9zbGF2ZV9hbGxvYywKIAkuc2xhdmVfY29u
ZmlndXJlCT0gYXRhX3Njc2lfc2xhdmVfY29uZmlnCiB9OwogCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2F0YS9zYXRhX252LmMgYi9kcml2ZXJzL2F0YS9zYXRhX252LmMKaW5kZXggYWJmNTY1
MWM4N2FiLi43NzE5Mzk0MGIzZjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYXRhL3NhdGFfbnYu
YworKysgYi9kcml2ZXJzL2F0YS9zYXRhX252LmMKQEAgLTM4MCw2ICszODAsNyBAQCBzdGF0
aWMgY29uc3Qgc3RydWN0IHNjc2lfaG9zdF90ZW1wbGF0ZSBudl9hZG1hX3NodCA9IHsKIAku
Y2FuX3F1ZXVlCQk9IE5WX0FETUFfTUFYX0NQQlMsCiAJLnNnX3RhYmxlc2l6ZQkJPSBOVl9B
RE1BX1NHVEJMX1RPVEFMX0xFTiwKIAkuZG1hX2JvdW5kYXJ5CQk9IE5WX0FETUFfRE1BX0JP
VU5EQVJZLAorCS5zbGF2ZV9hbGxvYwkJPSBhdGFfc2NzaV9zbGF2ZV9hbGxvYywKIAkuc2xh
dmVfY29uZmlndXJlCT0gbnZfYWRtYV9zbGF2ZV9jb25maWcsCiAJLnNkZXZfZ3JvdXBzCQk9
IGF0YV9uY3Ffc2Rldl9ncm91cHMsCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aCAgICAgPSBhdGFf
c2NzaV9jaGFuZ2VfcXVldWVfZGVwdGgsCkBAIC0zOTEsNiArMzkyLDcgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBzY3NpX2hvc3RfdGVtcGxhdGUgbnZfc3duY3Ffc2h0ID0gewogCS5jYW5f
cXVldWUJCT0gQVRBX01BWF9RVUVVRSAtIDEsCiAJLnNnX3RhYmxlc2l6ZQkJPSBMSUJBVEFf
TUFYX1BSRCwKIAkuZG1hX2JvdW5kYXJ5CQk9IEFUQV9ETUFfQk9VTkRBUlksCisJLnNsYXZl
X2FsbG9jCQk9IGF0YV9zY3NpX3NsYXZlX2FsbG9jLAogCS5zbGF2ZV9jb25maWd1cmUJPSBu
dl9zd25jcV9zbGF2ZV9jb25maWcsCiAJLnNkZXZfZ3JvdXBzCQk9IGF0YV9uY3Ffc2Rldl9n
cm91cHMsCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aCAgICAgPSBhdGFfc2NzaV9jaGFuZ2VfcXVl
dWVfZGVwdGgsCmRpZmYgLS1naXQgYS9kcml2ZXJzL2F0YS9zYXRhX3NpbDI0LmMgYi9kcml2
ZXJzL2F0YS9zYXRhX3NpbDI0LmMKaW5kZXggZTcyYTAyNTc5OTBkLi5lZDA5ZDY1Mzc0MWYg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYXRhL3NhdGFfc2lsMjQuYworKysgYi9kcml2ZXJzL2F0
YS9zYXRhX3NpbDI0LmMKQEAgLTM4MSw2ICszODEsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0
IHNjc2lfaG9zdF90ZW1wbGF0ZSBzaWwyNF9zaHQgPSB7CiAJLnRhZ19hbGxvY19wb2xpY3kJ
PSBCTEtfVEFHX0FMTE9DX0ZJRk8sCiAJLnNkZXZfZ3JvdXBzCQk9IGF0YV9uY3Ffc2Rldl9n
cm91cHMsCiAJLmNoYW5nZV9xdWV1ZV9kZXB0aAk9IGF0YV9zY3NpX2NoYW5nZV9xdWV1ZV9k
ZXB0aCwKKwkuc2xhdmVfYWxsb2MJCT0gYXRhX3Njc2lfc2xhdmVfYWxsb2MsCiAJLnNsYXZl
X2NvbmZpZ3VyZQk9IGF0YV9zY3NpX3NsYXZlX2NvbmZpZwogfTsKIApkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9saWJhdGEuaCBiL2luY2x1ZGUvbGludXgvbGliYXRhLmgKaW5kZXgg
ODIwZjdhM2EyNzQ5Li41OTBkZWQ4ZTMxOWQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgv
bGliYXRhLmgKKysrIGIvaW5jbHVkZS9saW51eC9saWJhdGEuaApAQCAtMTE1MSw2ICsxMTUx
LDcgQEAgZXh0ZXJuIGludCBhdGFfc3RkX2Jpb3NfcGFyYW0oc3RydWN0IHNjc2lfZGV2aWNl
ICpzZGV2LAogCQkJICAgICAgc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwKIAkJCSAgICAg
IHNlY3Rvcl90IGNhcGFjaXR5LCBpbnQgZ2VvbVtdKTsKIGV4dGVybiB2b2lkIGF0YV9zY3Np
X3VubG9ja19uYXRpdmVfY2FwYWNpdHkoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2KTsKK2V4
dGVybiBpbnQgYXRhX3Njc2lfc2xhdmVfYWxsb2Moc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2
KTsKIGV4dGVybiBpbnQgYXRhX3Njc2lfc2xhdmVfY29uZmlnKHN0cnVjdCBzY3NpX2Rldmlj
ZSAqc2Rldik7CiBleHRlcm4gdm9pZCBhdGFfc2NzaV9zbGF2ZV9kZXN0cm95KHN0cnVjdCBz
Y3NpX2RldmljZSAqc2Rldik7CiBleHRlcm4gaW50IGF0YV9zY3NpX2NoYW5nZV9xdWV1ZV9k
ZXB0aChzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsCkBAIC0xNDEzLDEyICsxNDE0LDE0IEBA
IGV4dGVybiBjb25zdCBzdHJ1Y3QgYXR0cmlidXRlX2dyb3VwICphdGFfY29tbW9uX3NkZXZf
Z3JvdXBzW107CiAJX19BVEFfQkFTRV9TSFQoZHJ2X25hbWUpLAkJCQlcCiAJLmNhbl9xdWV1
ZQkJPSBBVEFfREVGX1FVRVVFLAkJXAogCS50YWdfYWxsb2NfcG9saWN5CT0gQkxLX1RBR19B
TExPQ19SUiwJCVwKKwkuc2xhdmVfYWxsb2MJCT0gYXRhX3Njc2lfc2xhdmVfYWxsb2MsCQlc
CiAJLnNsYXZlX2NvbmZpZ3VyZQk9IGF0YV9zY3NpX3NsYXZlX2NvbmZpZwogCiAjZGVmaW5l
IEFUQV9TVUJCQVNFX1NIVF9RRChkcnZfbmFtZSwgZHJ2X3FkKQkJCVwKIAlfX0FUQV9CQVNF
X1NIVChkcnZfbmFtZSksCQkJCVwKIAkuY2FuX3F1ZXVlCQk9IGRydl9xZCwJCQlcCiAJLnRh
Z19hbGxvY19wb2xpY3kJPSBCTEtfVEFHX0FMTE9DX1JSLAkJXAorCS5zbGF2ZV9hbGxvYwkJ
PSBhdGFfc2NzaV9zbGF2ZV9hbGxvYywJCVwKIAkuc2xhdmVfY29uZmlndXJlCT0gYXRhX3Nj
c2lfc2xhdmVfY29uZmlnCiAKICNkZWZpbmUgQVRBX0JBU0VfU0hUKGRydl9uYW1lKQkJCQkJ
XAotLSAKMi40MS4wCgo=

--------------bF6QaiUtzo0gJ30Vc16x27lO--
