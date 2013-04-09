From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: mpt2sas + raid10 goes boom
Date: Tue, 09 Apr 2013 14:45:48 +0200
Message-ID: <51640D7C.9060106@matthiasprager.de>
References: <5162C25C.3090707@matthiasprager.de> <5162F827.7010603@matthiasprager.de> <CAC9+anJ4pdJ7EVwDQY-QpVOVr-L3xf5STuVaZ=i9bkFz5KuO3g@mail.gmail.com> <5163E941.1050907@matthiasprager.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <5163E941.1050907@matthiasprager.de>
Sender: linux-ext4-owner@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Matthias Prager <linux@matthiasprager.de>, linux-ext4@vger.kernel.org, Chris Dunlop <chris@onthe.net.au>
List-Id: linux-scsi@vger.kernel.org

Hello everyone,

an update: I was able to reproduce the problem on my testing
machine (at least sort of) and confirmed that
  c8dc9c6 md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
fixes things.
Also applied c8dc9c6 to the main system's 3.8.6 kernel. Working without
any issues.

One interesting detail: on the testing system's 9240-8i lsi controller
(megaraid_sas instead of mpt2sas driver) the log messages where
different and seemingly not coming from controller errors:

Apr  9 12:59:17 kernel: bio too big device sdb (4096 > 256)
Apr  9 12:59:17 kernel: md12: WRITE SAME failed. Manually zeroing.

Whereas the lsi 9211-8i gave these messages:

[ 2772.726292] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2772.726296] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2772.940873] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2773.205568] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2773.953718] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2774.203121] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2774.452462] mpt2sas0: log_info(0x31120320): originator(PL), code(0x12), sub_code(0x0320)
[ 2774.452476] sd 0:0:4:0: [sde] Unhandled error code
[ 2774.452479] sd 0:0:4:0: [sde]  
[ 2774.452480] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
[ 2774.452482] sd 0:0:4:0: [sde] CDB: 
[ 2774.452483] Write(10): 2a 00 a9 84 24 08 00 00 08 00
[ 2774.452491] end_request: I/O error, dev sde, sector 2844009480
[ 2774.452636] md3: WRITE SAME failed. Manually zeroing.

The former one looks a lot more friendly to me.

@lsi guys: this reveals a bug in the mpt2sas driver and/or
           the 9211&co series firmware, correct?

Thanks everyone for your help so far,
Matthias
