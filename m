From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5.63-mm2
Date: Wed, 5 Mar 2003 13:33:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030305133305.A16075@beaverton.ibm.com>
References: <20030302180959.3c9c437a.akpm@digeo.com> <1046815078.12931.79.camel@ibm-b> <20030304234042.2553deed.akpm@digeo.com> <20030305173854.GA1090@beaverton.ibm.com> <20030305185231.GE1090@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030305185231.GE1090@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Mar 05, 2003 at 10:52:31AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>, Mark Wong <markw@osdl.org>, linux-scsi@vger.kernel.org

On Wed, Mar 05, 2003 at 10:52:31AM -0800, Mike Anderson wrote:
> The patch below fixed the problem on my system. I had my list empty
> checks reversed if aborting and bus device reset failed. The condition
> that causes the error handler to run is still unknown. I will look at it
> when I get a chance.

Mike -

With your patch, I am able to boot again using the feral driver with an
isp1020 (on a NUMAQ system).

Though I still do not know why the feral gets a time out but qlogicisp
does not. It is apparently a read that times out while mounting root for
the first time (readonly), so this is not the first read sent to the drive
(partition code should have sent a read). It could be the queue_depth
settings (qlogicisp sets to 1, I have feral setting them to 16).

On boot with (SCSI error logging on) I see:

[ ... ]

TCP: Hash tables configured (established 524288 bind 65536)
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
isp6: Loop ID 125, AL_PA 0x1, Port ID 0x1, Loop State 0x2, Topology
'Private Loop'
Error handler scsi_eh_0 waking up
Error handler scsi_eh_0 waking up
scsi_eh_prt_fail_stats: 0:0:0:0 cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_0: aborting cmd:0xc3f4e600
scsi_eh_0: aborting cmd failed:0xc3f4e600
scsi_eh_0: Sending BDR sdev: 0xc3fba600
isp0: Interrupting Mailbox Command (0x17) Timeout
isp0: Mailbox Command 'ABORT TARGET' failed (TIMEOUT)
scsi_eh_0: BDR failed sdev:0xc3fba600
scsi_eh_0: Sending BRST chan: 0
scsi_try_bus_reset: Snd Bus RST
isp0: Interrupting Mailbox Command (0x18) Timeout
isp0: Mailbox Command 'BUS RESET' failed (TIMEOUT)
scsi_eh_0: BRST failed chan: 0
scsi_eh_0: Sending HRST
scsi_try_host_reset: Snd Host RST
isp0: Differential Mode
isp0: Ultra Mode Capable
isp0: Board Type 1040B, Chip Revision 0x5, loaded F/W Revision 4.66.0
isp0: Last F/W revision was 4.40.0
scsi_eh_done scmd: c3f4e600 result: 2
scsi_send_eh_cmnd: scmd: c3f4e600, rtn:2002
scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
scsi_eh_tur: scmd c3f4e600 rtn 2002
scsi_eh_0: flush retry cmd: c3f4e600
scsi_restart_operations: waking up host to restart
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 112k freed
INIT: version 2.78 booting

[ ... ]

-- Patrick Mansfield
