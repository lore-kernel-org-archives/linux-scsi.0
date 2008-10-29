From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: Timeout regression introduced by
	242f9dcb8ba6f68fcd217a119a7648a4f69290e9
Date: Wed, 29 Oct 2008 11:51:25 -0700
Message-ID: <20081029185125.GB9143@linux.vnet.ibm.com>
References: <49043C7C.8050207@kernel.org> <1225034105.3958.4.camel@localhost.localdomain> <49051EA4.3040403@kernel.org> <20081027213006.GB17946@linux.vnet.ibm.com> <490666D6.8090603@kernel.org> <20081029132654.GE31673@kernel.dk> <1225288976.3257.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1225288976.3257.5.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Tejun Heo <tj@kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Wed, 2008-10-29 at 14:26 +0100, Jens Axboe wrote:
> > On Tue, Oct 28 2008, Tejun Heo wrote:
> > > Mike Anderson wrote:
> > > > Tejun Heo <tj@kernel.org> wrote:
> > > >> James Bottomley wrote:
> > > >>> On Sun, 2008-10-26 at 18:46 +0900, Tejun Heo wrote:
> > > >>>> Hello, Jens.
> > > >>>>
> > > >>>> Commit 242f9dcb8ba6f68fcd217a119a7648a4f69290e9 introduces a strange
> > > >>>> regression for libata.  The second timeout gives puts different
> > > >>>> pointer from the issued command onto eh_cmd_q breaking libata EH
> > > >>>> command matching which triggers WARN_ON() in ata_eh_finish() and hangs
> > > >>>> command processing or causes oops later depending on circumstances.
> > > >>>>
> > > >>>> Here are logs with induced timeouts (patch attached).  In commit
> > > >>>> 242f9dcb8, the XXX messages for the second timeout shows different
> > > >>>> scsi_cmd pointers for eh_cmd_q and qc->scmd which is initialized by
> > > >>>> ata_scsi_qc_new() during command translation.
> > > >>> I can't see a way we could be getting a different command passed in from
> > > >>> the actual one, since the only way to lose the command from the request
> > > >>> is to go through the command completion routines which free it (and end
> > > >>> the request).
> > > >> I have no idea either.  It's something in the timeout logic because on
> > > >> the issue path the scmd pointer is identical but on tiemout pointer
> > > >> for another scmd is queued on eh_cmd_q, which doesn't make much sense.
> > > >>
> > > > 
> > > > I was trying to recreate this error using ata_ram wth v2.6.28-rc2.
> > > > Currently I am not able to see this error on timeout recovery using this
> > > > setup. Does IO load (or other factors) effect the error being seen?
> > > 
> > > Not at all.  That's the only write command I issued.
> > 
> > It's all extremely puzzling. Any chance I could talk you into stuffing
> > some debug printks in there to see what the hell is going on?
> 
> Right ... me too.  The number one thing I want to see is what SCSI
> commands are going to what controllers ... that might tell us which one
> is bogus and where it's coming from.

We may also want to update the debug output in ata_scsi_error.

I modified my debug output on my patched version of ata_ram plus the
logging in ata_scsi_error to print out more that tag zero. It appears as I
change my tests I switch from tag 0 to tag 7. Tejun it would be good to
see if your failing case is using another tag value also.

I provided a sample of my dmesg output where that failing cmd was tag 0 and then
switch to tag 7. The output was generated with a patched version of
ata_ram that will drop reads and writes based on a debugfs attribute. I
also have "scsi_logging_level --mlcomplete 1 --error 4 -s"

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com

Oct 29 11:12:47 lab_system kernel: [ 1725.986250] ata_dbg: ata_ram_device_thread dropped cmd=c8 (ed 0) 
Oct 29 11:12:47 lab_system kernel: [ 1725.986359] sd 3:0:0:0: [sdj] 1048576 512-byte hardware sectors: (536 MB/512 MiB)
Oct 29 11:12:47 lab_system kernel: [ 1725.986404] sd 3:0:0:0: [sdj] Write Protect is off
Oct 29 11:12:47 lab_system kernel: [ 1725.986406] sd 3:0:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 29 11:12:47 lab_system kernel: [ 1725.986480] sd 3:0:0:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
Oct 29 11:12:57 lab_system kernel: [ 1735.986307] sd 3:0:0:0: [sdj] Done: TIMEOUT
Oct 29 11:12:57 lab_system kernel: [ 1735.986311] sd 3:0:0:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Oct 29 11:12:57 lab_system kernel: [ 1735.986316] sd 3:0:0:0: [sdj] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
Oct 29 11:12:57 lab_system kernel: [ 1735.986325] sd 3:0:0:0: [sdj] Unrecognized sense data (in hex):
Oct 29 11:12:57 lab_system kernel: [ 1735.986329]         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Oct 29 11:12:57 lab_system kernel: [ 1735.986340]         00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
Oct 29 11:12:57 lab_system kernel: [ 1735.986351] Sense Key : No Sense [current] 
Oct 29 11:12:57 lab_system kernel: [ 1735.986354] sd 3:0:0:0: [sdj] Add. Sense: No additional sense information
Oct 29 11:12:57 lab_system kernel: [ 1735.986359] ata1: ata_dbg: ata_scsi_timed_out Enter
Oct 29 11:12:57 lab_system kernel: [ 1735.986361] ata1: ata_dbg: ata_scsi_timed_out ops->error_handler set
Oct 29 11:12:57 lab_system kernel: [ 1735.986364] ata1: ata_dbg: ata_scsi_timed_out active_tag 0, scmd=ffff88007d82d7c0
Oct 29 11:12:57 lab_system kernel: [ 1735.986366] ata1: ata_dbg: ata_scsi_timed_out EXIT ret=0
Oct 29 11:12:57 lab_system kernel: [ 1735.986368] ata_dbg: scsi_times_out eh_timed_out rtn = 0
Oct 29 11:12:57 lab_system kernel: [ 1735.986414] Error handler scsi_eh_3 waking up
Oct 29 11:12:57 lab_system kernel: [ 1735.986419] ata1: ata_dbg: eh_cmd_q: ffff88007d82d7c0
Oct 29 11:12:57 lab_system kernel: [ 1735.986422] ata1: ata_dbg: tag 0, qc 0, cmd c8, flags 0000000b, scmd ffff88007d82d7c0
Oct 29 11:12:57 lab_system kernel: [ 1735.986425] ata1: ata_dbg: tag 1, qc -84148995, cmd 60, flags 00000000, scmd ffff88007d82dcc0
Oct 29 11:12:57 lab_system kernel: [ 1735.986427] ata1: ata_dbg: tag 2, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986430] ata1: ata_dbg: tag 3, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986433] ata1: ata_dbg: tag 4, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986435] ata1: ata_dbg: tag 5, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986438] ata1: ata_dbg: tag 6, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986441] ata1: ata_dbg: tag 7, qc -84148995, cmd ca, flags 00000000, scmd ffff880037856b80
Oct 29 11:12:57 lab_system kernel: [ 1735.986444] ata1: ata_dbg: tag 8, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986446] ata1: ata_dbg: tag 9, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986449] ata1: ata_dbg: tag 10, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986452] ata1: ata_dbg: tag 11, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986454] ata1: ata_dbg: tag 12, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986457] ata1: ata_dbg: tag 13, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986460] ata1: ata_dbg: tag 14, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986462] ata1: ata_dbg: tag 15, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986465] ata1: ata_dbg: tag 16, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986468] ata1: ata_dbg: tag 17, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986471] ata1: ata_dbg: tag 18, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986473] ata1: ata_dbg: tag 19, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986476] ata1: ata_dbg: tag 20, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986479] ata1: ata_dbg: tag 21, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986481] ata1: ata_dbg: tag 22, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986484] ata1: ata_dbg: tag 23, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986487] ata1: ata_dbg: tag 24, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986489] ata1: ata_dbg: tag 25, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986492] ata1: ata_dbg: tag 26, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986495] ata1: ata_dbg: tag 27, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986497] ata1: ata_dbg: tag 28, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986500] ata1: ata_dbg: tag 29, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986503] ata1: ata_dbg: tag 30, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986506] ata1: ata_dbg: tag 31, qc -84148995, cmd ec, flags 00000000, scmd 0000000000000000
Oct 29 11:12:57 lab_system kernel: [ 1735.986516] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Oct 29 11:12:57 lab_system kernel: [ 1735.986522] ata1.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0 dma 4096 in
Oct 29 11:12:57 lab_system kernel: [ 1735.986524]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 29 11:12:57 lab_system kernel: [ 1735.986526] ata1.00: status: { DRDY }
Oct 29 11:12:57 lab_system kernel: [ 1735.986534] ata1: hard resetting link
Oct 29 11:12:57 lab_system kernel: [ 1735.986558] ata_dbg: ata_ram_execute_command completing tag 31, cmd ec
Oct 29 11:12:57 lab_system kernel: [ 1735.986601] ata_dbg: ata_ram_execute_command completing tag 31, cmd ef
Oct 29 11:12:57 lab_system kernel: [ 1735.986620] ata_dbg: ata_ram_execute_command completing tag 31, cmd ec
Oct 29 11:12:57 lab_system kernel: [ 1735.986642] ata1.00: configured for UDMA/33
Oct 29 11:12:57 lab_system kernel: [ 1735.986650] scsi_eh_3: flush retry cmd: ffff88007d82d7c0
Oct 29 11:12:57 lab_system kernel: [ 1735.986663] ata1: EH complete
Oct 29 11:12:57 lab_system kernel: [ 1735.986670] scsi_restart_operations: waking up host to restart
Oct 29 11:12:57 lab_system kernel: [ 1735.986688] Error handler scsi_eh_3 sleeping
Oct 29 11:12:57 lab_system kernel: [ 1735.986698] ata_dbg: ata_ram_execute_command completing tag 0, cmd c8
Oct 29 11:12:57 lab_system kernel: [ 1735.986826] ata_dbg: ata_ram_execute_command completing tag 7, cmd ca
Oct 29 11:12:57 lab_system kernel: [ 1735.986923] sd 3:0:0:0: [sdj] 1048576 512-byte hardware sectors: (536 MB/512 MiB)
Oct 29 11:12:57 lab_system kernel: [ 1735.986974] sd 3:0:0:0: [sdj] Write Protect is off
Oct 29 11:12:57 lab_system kernel: [ 1735.986977] sd 3:0:0:0: [sdj] Mode Sense: 00 3a 00 00
Oct 29 11:12:57 lab_system kernel: [ 1735.987064] sd 3:0:0:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA


Oct 29 11:16:52 lab_system root[5410]: ATA_RAM Fail Writei, Two Writers, bs=64k (Count 2, Drop Count 8)
Oct 29 11:17:18 lab_system kernel: [ 1996.270770] ata_dbg: ata_ram_device_thread dropped cmd=ca (ed 7) 
Oct 29 11:17:28 lab_system kernel: [ 2007.002206] sd 3:0:0:0: [sdj] Done: TIMEOUT
Oct 29 11:17:28 lab_system kernel: [ 2007.002212] sd 3:0:0:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
Oct 29 11:17:28 lab_system kernel: [ 2007.002217] sd 3:0:0:0: [sdj] CDB: Write(10): 2a 00 00 00 00 00 00 01 00 00
Oct 29 11:17:28 lab_system kernel: [ 2007.002229] ata1: ata_dbg: ata_scsi_timed_out Enter
Oct 29 11:17:28 lab_system kernel: [ 2007.002232] ata1: ata_dbg: ata_scsi_timed_out ops->error_handler set
Oct 29 11:17:28 lab_system kernel: [ 2007.002235] ata1: ata_dbg: ata_scsi_timed_out active_tag 7, scmd=ffff880037856380
Oct 29 11:17:28 lab_system kernel: [ 2007.002237] ata1: ata_dbg: ata_scsi_timed_out EXIT ret=0
Oct 29 11:17:28 lab_system kernel: [ 2007.002239] ata_dbg: scsi_times_out eh_timed_out rtn = 0
Oct 29 11:17:28 lab_system kernel: [ 2007.002264] Error handler scsi_eh_3 waking up
Oct 29 11:17:28 lab_system kernel: [ 2007.002271] ata1: ata_dbg: eh_cmd_q: ffff880037856380
Oct 29 11:17:28 lab_system kernel: [ 2007.002274] ata1: ata_dbg: tag 0, qc -84148995, cmd c8, flags 00000000, scmd ffff88007d82d7c0
Oct 29 11:17:28 lab_system kernel: [ 2007.002277] ata1: ata_dbg: tag 1, qc -84148995, cmd 60, flags 00000000, scmd ffff88007d82dcc0
Oct 29 11:17:28 lab_system kernel: [ 2007.002280] ata1: ata_dbg: tag 2, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002283] ata1: ata_dbg: tag 3, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002286] ata1: ata_dbg: tag 4, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002288] ata1: ata_dbg: tag 5, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002291] ata1: ata_dbg: tag 6, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002294] ata1: ata_dbg: tag 7, qc 7, cmd ca, flags 0000000b, scmd ffff880037856380
Oct 29 11:17:28 lab_system kernel: [ 2007.002296] ata1: ata_dbg: tag 8, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002299] ata1: ata_dbg: tag 9, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002302] ata1: ata_dbg: tag 10, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002304] ata1: ata_dbg: tag 11, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002307] ata1: ata_dbg: tag 12, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002310] ata1: ata_dbg: tag 13, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002312] ata1: ata_dbg: tag 14, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002315] ata1: ata_dbg: tag 15, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002318] ata1: ata_dbg: tag 16, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002321] ata1: ata_dbg: tag 17, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002323] ata1: ata_dbg: tag 18, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002326] ata1: ata_dbg: tag 19, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002329] ata1: ata_dbg: tag 20, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002331] ata1: ata_dbg: tag 21, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002334] ata1: ata_dbg: tag 22, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002337] ata1: ata_dbg: tag 23, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002339] ata1: ata_dbg: tag 24, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002342] ata1: ata_dbg: tag 25, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002345] ata1: ata_dbg: tag 26, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002347] ata1: ata_dbg: tag 27, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002350] ata1: ata_dbg: tag 28, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002353] ata1: ata_dbg: tag 29, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002355] ata1: ata_dbg: tag 30, qc 0, cmd 0, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002358] ata1: ata_dbg: tag 31, qc -84148995, cmd ec, flags 00000000, scmd 0000000000000000
Oct 29 11:17:28 lab_system kernel: [ 2007.002371] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
Oct 29 11:17:28 lab_system kernel: [ 2007.002379] ata1.00: cmd ca/00:00:00:00:00/00:00:00:00:00/e0 tag 7 dma 131072 out
Oct 29 11:17:28 lab_system kernel: [ 2007.002380]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Oct 29 11:17:28 lab_system kernel: [ 2007.002383] ata1.00: status: { DRDY }
Oct 29 11:17:28 lab_system kernel: [ 2007.002391] ata1: hard resetting link
Oct 29 11:17:28 lab_system kernel: [ 2007.002421] ata_dbg: ata_ram_execute_command completing tag 31, cmd ec
Oct 29 11:17:28 lab_system kernel: [ 2007.002477] ata_dbg: ata_ram_execute_command completing tag 31, cmd ef
Oct 29 11:17:28 lab_system kernel: [ 2007.002499] ata_dbg: ata_ram_execute_command completing tag 31, cmd ec
Oct 29 11:17:28 lab_system kernel: [ 2007.002526] ata1.00: configured for UDMA/33
Oct 29 11:17:28 lab_system kernel: [ 2007.002536] scsi_eh_3: flush retry cmd: ffff880037856380
Oct 29 11:17:28 lab_system kernel: [ 2007.002555] ata1: EH complete
