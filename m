From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Enhanced error handling
Date: Mon, 22 Jul 2002 20:16:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020723031633.44218.qmail@web14008.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello!
After reading a bunch about the new error handling
code, I have a few
questions.

I am a low level HBA driver, and the abort handler is
called while the
io request lock is held. An abort might be completed
immediately (
might need to send out an ABORT frame  and wait for
its completion)
and therefore might be completed asynchronously. So I
might need to
sleep in the abort thread, because from what I read,
it indicated that once the abort call returns, we
cannot call scsi_done. So the best thing would be to
wait for the abort to complete.

So my question is:
If interrupts are disabled when the error handler
thread is called,
and I have to sleep, how do I re-enable interrupts ,
because the abort
completion is via an interrupt! Ditto with bus reset,
device reset
etc. How do I get a completion at all? Timer
interrupts are also
disabled on a UP system so how does someone get a
completion at all??
If I have to re-enable interrupts in the error handler
by calling
irqrestore, I need the flags , and the low level
driver does not have
access to the flags at all. Looking at some sample
SCSI drivers,they
seem to be queuing up the abort and returning SUCCESS.
But there is a
problem there..the mid layer thinks the IO is done and
freed. Say we
reported as 20 the maximum commands we support,
wouldnt the mid layer
send 20 commands down( obviously if it had 20..) ,
when actually the
low level driver should be getting 19 because the
abort of the IO
might not have completed? Either my understanding is
totally wrong, or
this model seems to be somewhat broken. Can someone
please shed some
light on this issue?

Thanks!
Mukul


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
