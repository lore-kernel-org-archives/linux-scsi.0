From: Matthew Jacob <mjacob@feral.com>
Subject: Re: Task Sets in SCSI and Linux
Date: Wed, 8 May 2002 09:51:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.BSF.4.21.0205080946300.58242-100000@beppo>
References: <200205081634.g48GYe304381@localhost.localdomain>
Reply-To: mjacob@feral.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200205081634.g48GYe304381@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Michael Heinz <mheinz@infiniconsys.com>, linux-scsi@vger.kernel.org

> 
> Could you elaborate on what you mean by "task set"?  SCSI 3 defines a task 
> simply as "work to be performed by the logical unit in the form of a command 
> or a group of linked commands".  This basically means the I_T_L or I_T_L_Q 
> nexus of scsi2, however scsi3 expands this for multi-ported devices.  "task 
> set" usually just means the outstanding tasks on a given logical unit, and as 
> such it's really a target concept although the initiator must know how to 
> track outstanding tasks correctly.

You can issue an FCP CMND IU with ABORT TASK SET as part of the task
management functions. It aborts all tasks (tagged commands) at the specified
lun for that initiator.

Consider it a 'bulk abort tag' operation.


At any rate, the answer is that Linux itself doesn't support this level of
granularity of aborting, as the sequence of error recovery for the midlayer is
(IIRC)

	abort tag -> reset device -> reset bus

for each timed out command. Individual HBA drivers may or may not support
this.

