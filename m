From: yang jun <yangjun.donglife123@gmail.com>
Subject: Re: [SCSI] sr: sr_mutex ,multi-drive performance is bad
Date: Wed, 30 Oct 2013 23:13:01 +0800
Message-ID: <CAO4Pk4wgzhcgh4F2N7Juicnvyk1xJqdsxEU=_Zwrb8K2Ats+vg@mail.gmail.com>
References: <CAO4Pk4wxUN-O_m5KcdZgmTTRG2w8icqva+0dxu7HRO=rEpbArg@mail.gmail.com>
	<526FCC06.6070908@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:45838 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3J3PNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2013 11:13:02 -0400
Received: by mail-vc0-f175.google.com with SMTP id ht10so1018793vcb.34
        for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2013 08:13:01 -0700 (PDT)
In-Reply-To: <526FCC06.6070908@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, otto.patches@sister-shadow.de

Hi, Jens,

Thanks for your response. When various processes compete for sr_mutex
in .open or .release, the performance will not be worse much, the
main degradation of performance is caused  by sr_block_ioctl which
can't release sr_mutex until one io comletes. So, shall we remove
sr_mutex only from sr_block_ioctl but still keep sr_mutex in .open and
=2Erelease?  Please advise.

Best regards,
Jun Yang

2013/10/29 Jens Axboe <axboe@kernel.dk>:
> On 10/28/2013 08:30 AM, yang jun wrote:
>> Dear Mr.Axboe,
>>
>> The latest kernel sr_module still uses single mutex,it will serialis=
e
>> all sr ioctls. Otto Meta had mentioned this on Jan 1st, 2013 . Some
>> record tools such as growisofs use SG_IO to write data to disc, so i=
f
>> there are multiple cdroms being recorded at the same time=A3=ACit wi=
ll be
>> very slowly.
>>
>> I saw sd_module before,it had removed BKL and made "openers" atomic_=
t
>> in scsi_disk. Shall we do the same thing to sr_module? That is, to
>> remove sr_mutex and make "use_count" atomic_t in cdrom_device_info.
>
> The same conversion that happened to sd could apply to sr just as eas=
ily.
>
> --
> Jens Axboe
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
