From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: When must the io_request_lock be held?
Date: Tue, 6 Aug 2002 10:58:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020806175822.37912.qmail@web14006.mail.yahoo.com>
References: <20020805195325.B19398@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20020805195325.B19398@ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>, linux-scsi@vger.kernel.org


--- Jamie Wellnitz <Jamie.Wellnitz@emulex.com> wrote:
> When does a low-level driver have to hold the
> io_request_lock?  I know
> that a driver should take the lock when it calls a
> SCSI command's done
> function.  Also, when the driver's queuecommand is
> entered, it already
> holds this lock.
> 
> I've seen some drivers that drop the lock (via
> either spin_unlock or
> spin_unlock_irq) inside their queuecommand.  What
> are the rules for
> dropping (and reacquiring) the lock here?
> 

If you drop the lock, you are responsible for the
synchronization of the driver. From what I know, the
io_request_lock is going to be removed from the code
in the later versions, so it is always a good idea not
to depend on the lock for synchronization and define
ur own, so that it becomes easier in the future.

You can drop the lock at the start if u have ur own
locks, and reacquire it at the end, because the mid
level expects it to be in the acquired state. 


Mukul



> Thanks,
> Jamie Wellnitz
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
