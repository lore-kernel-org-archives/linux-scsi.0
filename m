From: =?iso-8859-1?q?Liong=20Hoong?= <liongshliongsh@yahoo.com>
Subject: Re: sg_io_hrd_t - host_status error (0x05)
Date: Fri, 7 May 2004 12:25:37 +0800 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040507042537.4356.qmail@web40007.mail.yahoo.com>
References: <40930334.4040908@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web40007.mail.yahoo.com ([66.218.78.25]:47794 "HELO
	web40007.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262914AbUEGEZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2004 00:25:37 -0400
In-Reply-To: <40930334.4040908@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Hi,

Below is the some coding extracted from the Linux
kernel. It seems that before the opcodes of Group4
(0x80 and 0x9f) able to pass down to the device, the
scsi.c already failed the commands thus yield the
DID_ABORT error. 

Is it possible to edit scsi.c or the host.c to allow
the Group4 opcodes pass down to scsi device. Why is
there having such a restriction in scsi.c/host.c when
the sg drivers is already support of 16 bytes command
size?

scsi.c
/*
 * Macro to determine the size of SCSI command. This
macro takes vendor
 * unique commands into account. SCSI commands in
groups 6 and 7 are
 * vendor unique and we will depend upon the command
length being
 * supplied correctly in cmd_len.
 */
#define CDB_SIZE(SCpnt)	((((SCpnt->cmnd[0] >> 5) & 7)
< 6) ? \
				COMMAND_SIZE(SCpnt->cmnd[0]) : SCpnt->cmd_len)

================================================================================================
scsi.c

/*
	 * Before we queue this command, check if the command
	 * length exceeds what the host adapter can handle.
*/
	if (CDB_SIZE(SCpnt) > host->max_cmd_len) {
		SCSI_LOG_MLQUEUE(3, printk("scsi_dispatch_cmd :
command too long %d(Max %d).\n", CDB_SIZE(SCpnt),
host->max_cmd_len));
		SCpnt->result = (DID_ABORT << 16);
		scsi_done(SCpnt);
		return 1;
	}

=======================================================================================
sg drivers notes

Linux kernel prior to 2.4.15 limited SCSI commands to
a length of 12 bytes. In lk 2.4.15 this was raised to
16 bytes. However unless lower level drivers (e.g.
aic7xxx) indicate that they can handle 16 byte
commands (and few currently do) then the command is
aborted with a DID_ABORT host status.

========================================================================
host.c

/*
     * All drivers right now should be able to handle
12 byte commands.
     * Every so often there are requests for 16 byte
commands, but individual
     * low-level drivers need to certify that they
actually do something
     * sensible with such commands.
*/
    retval->max_cmd_len = 12;

=========================================================================
host.h

/*
     * The maximum length of SCSI commands that this
host can accept.
     * Probably 12 for most host adapters, but could
be 16 for others.
     * For drivers that don't set this field, a value
of 12 is
     * assumed.  I am leaving this as a number rather
than a bit
     * because you never know what subsequent SCSI
standards might do
     * (i.e. could there be a 20 byte or a 24-byte
command a few years
     * down the road?).  
*/

    unsigned char max_cmd_len;

Regards,
Sean

 --- Douglas Gilbert <dougg@torque.net> wrote: > Liong
Hoong wrote:
> > Hi,
> > 
> > Sorry if there is any misunderstanding in my
> previous
> > questions.
> > I would like to ask, 
> > I am using Linux Red Hat 8.0, kernel 2.4.18. I
> used
> > the SG driver version 3 without any modification
> of
> > the kernel. I encountered host_status error (0x05)
> > ONLY on sending opcodes from 0x80 to 0x9f. Can
> anyone
> > give me hints on why or which part of the kernel
> codes
> > that might failed this specific range of opcodes?
> Or
> > is there any work around or patches? Anyone out
> there
> > did experience similar problems and like to share
> with
> > me?
> 
> Sean,
> I assume that you have already determined (via
> another OS)
> that the device really does accept 16 byte SCSI
> commands
> in that opcode range.
> 
> As mentioned in my previous post the 12 to 16 byte
> cdb
> expansion occurred in lk 2.4.15. Maybe the
> usb-storage driver
> took a few versions to catch up. Apart from vendor
> specific
> commands, there would not be a lot of demand for the
> usb-storage driver to support 16 byte commands.
> Perhaps you should try a more recent version of the
> linux
> kernel. If the problem persists then you are more
> likely to
> get help.
> 
> Doug Gilbert
> 
> 
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html 


__________________________________________________
Do You Yahoo!?
Log on to Messenger with your mobile phone!
http://sg.messenger.yahoo.com
