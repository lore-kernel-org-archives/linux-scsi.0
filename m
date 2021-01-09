Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE8EEC433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 04:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FC6A23A1E
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 04:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbhAIEqJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 23:46:09 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:62381 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAIEqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2021 23:46:06 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610167544; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Type: MIME-Version: Sender;
 bh=pldRch0XeQ8YLuuVoWAbIdZLnaFptB4b6IzdOyM8/lo=; b=lGo5gHmxRpeWhKzASUxxDWi+rkX29hwkNL9k024Hb3xrnM9ETt2Tb9tHEmwUMcy1kSCer1d3
 AZmHLz2KFUSxQzuU17z/UWpEWQpt99hyUe8IhFi4T96pT5FmVhol7VfKqUQmqHZwcq552zwU
 nCxOyfoRXyDhkep2khxDrnlg13w=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n10.prod.us-east-1.postgun.com with SMTP id
 5ff934d7f1be2d22c4796e58 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 09 Jan 2021 04:45:11
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2D226C433CA; Sat,  9 Jan 2021 04:45:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25B63C433CA;
        Sat,  9 Jan 2021 04:45:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_74d452260b1f2d1f08e4752511c5ef65"
Date:   Sat, 09 Jan 2021 12:45:08 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        rjw@rjwysocki.net, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Nitin Rawat <nitirawa@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] scsi: ufs: Protect PM ops and err_handler from user
 access through sysfs
In-Reply-To: <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
 <1609595975-12219-3-git-send-email-cang@codeaurora.org>
 <80a15afab8024d0b61d312b57585c9322ac91958.camel@gmail.com>
 <7d49c1dfc3f648c484076f3c3a7f4e1e@codeaurora.org>
 <1514403adf486ac8069253c09f45b021bad32e00.camel@gmail.com>
 <f814b71d1d4ea87a72df4851a8190807@codeaurora.org>
 <cb388d8ea15b2c80a072dec74d9ededecb183a08.camel@gmail.com>
Message-ID: <e69bd5a6b73d5c652130bf4fa077aac0@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=_74d452260b1f2d1f08e4752511c5ef65
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2021-01-08 19:29, Bean Huo wrote:
> On Wed, 2021-01-06 at 09:20 +0800, Can Guo wrote:
>> Hi Bean,
>> 
>> On 2021-01-06 02:38, Bean Huo wrote:
>> > On Tue, 2021-01-05 at 09:07 +0800, Can Guo wrote:
>> > > On 2021-01-05 04:05, Bean Huo wrote:
>> > > > On Sat, 2021-01-02 at 05:59 -0800, Can Guo wrote:
>> > > > > + * @shutting_down: flag to check if shutdown has been
>> > > > > invoked
>> > > >
>> > > > I am not much sure if this flag is need, since once PM going in
>> > > > shutdown path, what will be returnded by pm_runtime_get_sync()?
>> > > >
>> > > > If pm_runtime_get_sync() will fail, just check its return.
>> > > >
>> > >
>> > > That depends. During/after shutdown, for UFS's case only,
>> > > pm_runtime_get_sync(hba->dev) will most likely return 0,
>> > > because it is already RUNTIME_ACTIVE, pm_runtime_get_sync()
>> > > will directly return 0... meaning you cannot count on it.
>> > >
>> > > Check Stanley's change -
>> > > https://lore.kernel.org/patchwork/patch/1341389/
>> > >
>> > > Can Guo.
>> >
>> > Can,
>> >
>> > Thanks for pointing out that.
>> >
>> > Based on my understanding, that patch is redundent. maybe I
>> > misundestood Linux shutdown sequence.
>> 
>> Sorry, do you mean Stanley's change is redundant?
> 
> yes.
> 

No, it is definitely needed. As Stanley replied you in another
thread, it is not protecting I/Os from user layer, but from
other subsystems during shutdown.

>> 
>> >
>> > I checked the shutdown flow:
>> >
>> > 1. Set the "system_state" variable
>> > 2. Disable usermod to ensure that no user from userspace can start
>> > a
>> > request
>> 
>> I hope it is like what you interpreted, but step #2 only stops
>> UMH(#265)
>> but not all user space activities. Whereas, UMH is for kernel space
>> calling
>> user space.
> 
> 
> Can,
> 
> I did further study and homework on the Linux shutdown in the last few
> days. Yes, you are right, usermodehelper_disable() is to prevent
> executing the process from the kernel space.
> 
> But I didn't reproduce this "maybe" race issue while shutdown. no
> matter how I torment my system, once Linux shutdown/halt/reboot starts,
> nobody can access the sysfs node. I create 10 processes in the user
> space and constantly access UFS sysfs node, also, fio is running in the
> background for the normal data read/write. there is a shutdown thread
> that will randomly trigger shutdown/halt/reboot. but no race issue
> appears.
> 
> I don't know if this is a hypothetical issue(the race between shutdown
> flow and sysfs node access), it may not really exist in the Linux
> envriroment. everytime, the shutdonw flow will be:
> 
> e10_sync_handler()->e10_svc()->do_e10_svc()->__do_sys_reboot()-
>> kernel_poweroff/kernel_halt()->device_shutdown()->platform_shutdown()-
>> ufshcd_platform_shutdown()->ufshcd_shutdown().
> 
> I think before going into the kernel shutdown, the userspace cannot
> issue new requests anymore. otherwise, this would be a big issue.
> 
> pm_runtime_get_sync() will return 0 or failure while shutdown? the
> answer is not important now, maybe as you said, it is always 0. But in
> my testing, it didn't get there the system has been shutdown. Which
> means once shutdonw starts, sysfs node access path cannot reach
> pm_runtime_get_sync(). (note, I don't know if sysfs node access thread
> has been disabled or not)
> 
> 
> Responsibly say, I didn't reproduce this issue on my system (ubuntu),
> maybe you are using Android. I am not an expert on this topic, if you
> have the best idea on how to reproduce this issue. please please let me
> try. appreciate it!!!!!
> 

When you do a reboot/shutdown/poweroff, how your system behaves highly
depends on how the reboot cmd is implemented in C code under /sbin/.

On Ubuntu, reboot looks like:
$ reboot --help
reboot [OPTIONS...] [ARG]

Reboot the system.

      --help      Show this help
      --halt      Halt the machine
   -p --poweroff  Switch off the machine
      --reboot    Reboot the machine
   -f --force     Force immediate halt/power-off/reboot
   -w --wtmp-only Don't halt/power-off/reboot, just write wtmp record
   -d --no-wtmp   Don't write wtmp record
      --no-wall   Don't send wall message before halt/power-off/reboot


On a pure Linux with a initrd RAM FS built from busybox, reboot looks 
like:
# reboot --help
BusyBox v1.30.1 (2019-05-24 12:53:36 IST) multi-call binary.

Usage: reboot [-d DELAY] [-n] [-f]

Reboot the system

         -d SEC  Delay interval
         -n      Do not sync
         -f      Force (don't go through init)


For example, when you work on a pure Linux with a filesystem built from
busybox, when you hit reboot cmd, halt_main() will be called. And based
on the reboot options passed to reboot cmd, halt_main() behaves 
differently.

A plain reboot cmd does things like sync filesystem, send SIGKILL to all
processes (except for init), remount all filesytem as read-only and so 
on
before invoking linux kernel reboot syscall. In this case, we are safe.

However, if you do a "reboot -f", halt_main() directly invokes reboot().
And with "reboot -f", I can easily reproduce the race condition we are
talking about here - it is not based on imagination.

Find the patch I used for replication in the attachment, fix conflicts
if any. After boot up, the cmd lines I used are

# while true; do cat /sys/devices/platform/soc@0/*ufshc*/rpm_lvl; done &
# reboot -f

Can Guo.

> 
> Thanks,
> Bean
> 
> 
>> 
>> 264     system_state = state;
>> 265     usermodehelper_disable();
>> 266     device_shutdown();
>> 
>> Thanks,
>> Can Guo.

--=_74d452260b1f2d1f08e4752511c5ef65
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=0001-scsi-ufs-Reproduce-race-condition-btw-sysfs-access-a.patch
Content-Disposition: attachment;
 filename=0001-scsi-ufs-Reproduce-race-condition-btw-sysfs-access-a.patch;
 size=1858

RnJvbSA2MzkzNThkZDZlMmY3ZTVlOWY3ZTY2YjgyOGJmMDQzZmEzYzdiYmYyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPgpEYXRlOiBT
YXQsIDkgSmFuIDIwMjEgMTI6Mzc6NDAgKzA4MDAKU3ViamVjdDogW1BBVENIXSBzY3NpOiB1ZnM6
IFJlcHJvZHVjZSByYWNlIGNvbmRpdGlvbiBidHcgc3lzZnMgYWNjZXNzIGFuZAogc2h1dGRvd24K
ClJlcHJvZHVjZSByYWNlIGNvbmRpdGlvbiBidHcgc3lzZnMgYWNjZXNzIGFuZCBzaHV0ZG93bgoK
VXNhZ2U6CgpTaWduZWQtb2ZmLWJ5OiBDYW4gR3VvIDxjYW5nQGNvZGVhdXJvcmEub3JnPgoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzLXN5c2ZzLmMgYi9kcml2ZXJzL3Njc2kvdWZz
L3Vmcy1zeXNmcy5jCmluZGV4IDkyYTYzZWUuLmEyOWE0OTAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c2NzaS91ZnMvdWZzLXN5c2ZzLmMKKysrIGIvZHJpdmVycy9zY3NpL3Vmcy91ZnMtc3lzZnMuYwpA
QCAtNTksNiArNTksOCBAQCBzdGF0aWMgc3NpemVfdCBycG1fbHZsX3Nob3coc3RydWN0IGRldmlj
ZSAqZGV2LAogewogCXN0cnVjdCB1ZnNfaGJhICpoYmEgPSBkZXZfZ2V0X2RydmRhdGEoZGV2KTsK
IAorCUJVR19PTihoYmEtPnNodXR0aW5nX2Rvd24pOworCiAJcmV0dXJuIHNwcmludGYoYnVmLCAi
JWRcbiIsIGhiYS0+cnBtX2x2bCk7CiB9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS91ZnMv
dWZzaGNkLmMgYi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jCmluZGV4IDY5OGU4ZDIuLjIxMGZh
NWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmMKKysrIGIvZHJpdmVycy9z
Y3NpL3Vmcy91ZnNoY2QuYwpAQCAtODI3Nyw2ICs4Mjc3LDExIEBAIGludCB1ZnNoY2Rfc2h1dGRv
d24oc3RydWN0IHVmc19oYmEgKmhiYSkKIHsKIAlpbnQgcmV0ID0gMDsKIAorCWhiYS0+c2h1dHRp
bmdfZG93biA9IHRydWU7CisJcHJfZXJyKCJbREVCVUddJXM6IFVGUyBTSFVURE9XTiBTVEFSVFxu
IiwgX19mdW5jX18pOworCisJdXNsZWVwX3JhbmdlKDEwMDAwMDAwLCAxMTAwMDAwMCk7CisKIAlp
ZiAoIWhiYS0+aXNfcG93ZXJlZCkKIAkJZ290byBvdXQ7CiAKQEAgLTgyOTQsNiArODI5OSw3IEBA
IGludCB1ZnNoY2Rfc2h1dGRvd24oc3RydWN0IHVmc19oYmEgKmhiYSkKIAlpZiAocmV0KQogCQlk
ZXZfZXJyKGhiYS0+ZGV2LCAiJXMgZmFpbGVkLCBlcnIgJWRcbiIsIF9fZnVuY19fLCByZXQpOwog
CS8qIGFsbG93IGZvcmNlIHNodXRkb3duIGV2ZW4gaW4gY2FzZSBvZiBlcnJvcnMgKi8KKwlwcl9l
cnIoIltERUJVR10lczogVUZTIFNIVVRET1dOIEVORFxuIiwgX19mdW5jX18pOwogCXJldHVybiAw
OwogfQogRVhQT1JUX1NZTUJPTCh1ZnNoY2Rfc2h1dGRvd24pOwpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zY3NpL3Vmcy91ZnNoY2QuaCBiL2RyaXZlcnMvc2NzaS91ZnMvdWZzaGNkLmgKaW5kZXggNmZm
YzA4YS4uM2E0MGQ5NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuaAorKysg
Yi9kcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oCkBAIC02NzcsNiArNjc3LDcgQEAgc3RydWN0IHVm
c19oYmEgewogCXUxNiBlZV9jdHJsX21hc2s7CiAJdTE2IGhiYV9lbmFibGVfZGVsYXlfdXM7CiAJ
Ym9vbCBpc19wb3dlcmVkOworCWJvb2wgc2h1dHRpbmdfZG93bjsKIAogCS8qIFdvcmsgUXVldWVz
ICovCiAJc3RydWN0IHdvcmtfc3RydWN0IGVoX3dvcms7Ci0tIApRdWFsY29tbSBJbm5vdmF0aW9u
IENlbnRlciwgSW5jLiBpcyBhIG1lbWJlciBvZiBDb2RlIEF1cm9yYSBGb3J1bSwgYSBMaW51eCBG
b3VuZGF0aW9uIENvbGxhYm9yYXRpdmUgUHJvamVjdC4KCg==
--=_74d452260b1f2d1f08e4752511c5ef65--
