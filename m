From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Tue, 11 Feb 2003 15:14:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E49598F.80409@splentec.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <3E492992.90502@splentec.com> <20030211172256.GC3164@beaverton.ibm.com> <3E494977.1070706@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
 >
 > 1. Is it possible that when a command times out, or when the application
 > client sends ABORT_TASK TMF (future), the eh thread wakes up and calls the driver's
 > abort function, without actually shutting down queueing or any other workings
 > of the host/driver/device?  Then let the LLDD cancel this command, all the while
 > the rest of the things can go on.

Yeah, the host_lock...

I'm not very fond of grabbing a spin lock calling a fn which may sleep
and then releasing the lock...

-- 
Luben


