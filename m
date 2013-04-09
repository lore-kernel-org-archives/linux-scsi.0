From: Matthias Prager <linux@matthiasprager.de>
Subject: Re: mpt2sas + raid10 goes boom
Date: Tue, 09 Apr 2013 12:11:13 +0200
Message-ID: <5163E941.1050907@matthiasprager.de>
References: <5162C25C.3090707@matthiasprager.de> <5162F827.7010603@matthiasprager.de> <CAC9+anJ4pdJ7EVwDQY-QpVOVr-L3xf5STuVaZ=i9bkFz5KuO3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <CAC9+anJ4pdJ7EVwDQY-QpVOVr-L3xf5STuVaZ=i9bkFz5KuO3g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, linux-ext4@vger.kernel.org, Chris Dunlop <chris@onthe.net.au>, Matthias Prager <linux@matthiasprager.de>
List-Id: linux-scsi@vger.kernel.org

Thanks for your insights Baruch.
The crc count did not increase any further - so this was probably just
small oddity (was zero before when the write-same issue already
happened). The real issue however does persist. I found a way to
reliably trigger the log messages. Using a program called checksum over
a photo share (which does a lot of reads and one write per file). With
that in place I switched to the 3.4.38 kernel, with which I'm unable to
trigger the problem. I will leave the system at that for now, and try to
reproduce it on my testing machine to see, whether
  c8dc9c6 md: raid1,10: Handle REQ_WRITE_SAME flag in write bios
works for me.

If c8dc9c6 does the trick, it would still be interesting to know why and
how this triggered i/o errors, the strange log message from lsi and
'Resets Between Cmd Acceptance and Completion' as one of the drives
says. Would that mean the driver/firmware from lsi is issuing or passing
on commands to the drive which it does not understand or can't process?

---
Matthias
