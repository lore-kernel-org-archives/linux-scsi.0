From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] Add a flight data recorder for scsi commands
Date: Tue, 27 Aug 2013 19:54:22 -0400
Message-ID: <20130827195422.0c23e47d@gandalf.local.home>
References: <20130827220325.GB7293@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24740 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3H0XyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2013 19:54:23 -0400
In-Reply-To: <20130827220325.GB7293@logfs.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 27 Aug 2013 18:03:25 -0400
J=C3=B6rn Engel <joern@logfs.org> wrote:

> Here is a fun patch in an early state.  Essentially I want to trace
> scsi commands, which has already been done long ago.  The problem I
> have is that I care about all the scsi commands for one particular
> device - without knowing in advance which device it will be.  Once I
> know the device in question, I want to dump the last X commands.

Is the device passed to the trace point? If so, you can add a filter on
that device. You can even create a separate buffer to just trace that
device.

cd /sys/kernel/debug/tracing
mkdir instances/myscsi
echo 'channel=3D=3D0 && id=3D=3D0 && lun=3D=3D0' > \
  instances/myscsi/events/scsi/scsi_dispatch_cmd_done/filter
echo 1 > instance/myscsi/events/scsi/scsi_dispatch_cmd_done/enable
cat instances/myscsi/trace
# tracer: nop
#
# entries-in-buffer/entries-written: 10/10   #P:4
#
#                              _-----=3D> irqs-off
#                             / _----=3D> need-resched
#                            | / _---=3D> hardirq/softirq
#                            || / _--=3D> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
          <idle>-0     [000] d.h3  8173.344559: scsi_dispatch_cmd_done:=
 host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D0 prot_=
op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D68117912 txlen=3D8 protect=3D=
0 raw=3D28 00 04 0f 65 98 00 00 08 00) result=3D(driver=3DDRIVER_OK hos=
t=3DDID_OK message=3DCOMMAND_COMPLETE status=3DSAM_STAT_GOOD)
          <idle>-0     [001] d.h3  8173.347743: scsi_dispatch_cmd_done:=
 host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D0 prot_=
op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D68351144 txlen=3D8 protect=3D=
0 raw=3D28 00 04 12 f4 a8 00 00 08 00) result=3D(driver=3DDRIVER_OK hos=
t=3DDID_OK message=3DCOMMAND_COMPLETE status=3DSAM_STAT_GOOD)
          <idle>-0     [000] d.h3  8174.810108: scsi_dispatch_cmd_done:=
 host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D0 prot_=
op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D61301272 txlen=3D8 protect=3D=
0 raw=3D28 00 03 a7 62 18 00 00 08 00) result=3D(driver=3DDRIVER_OK hos=
t=3DDID_OK message=3DCOMMAND_COMPLETE status=3DSAM_STAT_GOOD)
          <idle>-0     [001] d.h3  8174.822038: scsi_dispatch_cmd_done:=
 host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D0 prot_=
op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D48718352 txlen=3D8 protect=3D=
0 raw=3D28 00 02 e7 62 10 00 00 08 00) result=3D(driver=3DDRIVER_OK hos=
t=3DDID_OK message=3DCOMMAND_COMPLETE status=3DSAM_STAT_GOOD)
          <idle>-0     [002] d.h3  8174.827439: scsi_dispatch_cmd_done:=
 host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D0 prot_=
op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D56582672 txlen=3D8 protect=3D=
0 raw=3D28 00 03 5f 62 10 00 00 08 00) result=3D(driver=3DDRIVER_OK hos=
t=3DDID_OK message=3DCOMMAND_COMPLETE status=3DSAM_STAT_GOOD)
          <idle>-0     [003] d.h3  8174.835280: scsi_dispatch_cmd_done:
          host_no=3D0 channel=3D0 id=3D0 lun=3D0 data_sgl=3D1 prot_sgl=3D=
0
          prot_op=3DSCSI_PROT_NORMAL cmnd=3D(READ_10 lba=3D82010640 txl

Is that something you are talking about?

-- Steve



>=20
> The existing tracing is covering all commands to all devices.  So
> either I have to oversize my trace buffer and dump way too much, or I
> will miss the stuff I am interested in most of the time.  Hence my
> per-device trace buffer (called fdr to avoid namespace collisions).
>=20
> Steven, is there some magic 2-line patch that would also give me what
> I want without having to reinvent all your infrastructure and doing
> such a bad job?
>=20
> J=C3=B6rn
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
