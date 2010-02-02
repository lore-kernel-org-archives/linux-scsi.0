From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: kernel BUG at cfq-iosched.c triggered by EMC multipathing
Date: Wed, 03 Feb 2010 00:27:08 +0100
Message-ID: <87ock7uskz.fsf@tac.ki.iif.hu>
References: <87tytzllva.fsf@tac.ki.iif.hu>
	<1265124149.2800.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1265124149.2800.41.camel@mulgrave.site> (James Bottomley's
	message of "Tue, 02 Feb 2010 09:22:29 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Eddie Williams <Eddie.Williams@steeleye.com>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> I don't see this on the SCSI reflector, so I suspect the size of the
> attachments was over the limit; trimming for a resend.
>
> On Tue, 2010-02-02 at 16:04 +0100, Ferenc Wagner wrote:
>> Far too often, but not always, a blade server freezes during boot.  My
>> feeling is that it happens more often when a (slow) Serial Over LAN
>> console connection is active, but I've got no hard data on this.  The
>> system is booted from SAN, using an Adaptec FC BIOS feature, but the
>> freeze always happens in the initramfs phase, when udev's discovering
>> the devices.  All this on a mostly up to date Debian Sid i686 system
>> under a 2.6.32.3-based Debian kernel (2.6.32-5).  Sorry for the
>> somewhat
>> broken logs, this is what the Bladecenter SOL gave me...
>> 
>> [   33.759484] sd 0:0:1:2: emc: connected to SP B Port 3 (owned,
>> default SP B)
>> [   33.801231] emc: device handler registered
>> [   33.830450] device-mapper: multipath round-robin: version 1.0.0
>> loaded
>> [   33.869763] sd 2:0:1:0: emc: at SP B Port 2 (owned, default SP B)
>> [   33.908577] sd 0:0:1:0: emc: at SP B Port 3 (owned, default SP B)
>> [   33.945720] ------------[ cut here ]------------
>> [   33.949646] kernel BUG
>> at /tmp/buildd/linux-2.6-2.6.32/debian/build/source_i386_none/block/cfq-iosched.c:2329!
>
> Without exact source, it's hard to be certain, but I'd suspect this bug
> on:
>
> static void cfq_put_queue(struct cfq_queue *cfqq)
> {
> 	struct cfq_data *cfqd = cfqq->cfqd;
> 	struct cfq_group *cfqg, *orig_cfqg;
>
> 	BUG_ON(atomic_read(&cfqq->ref) <= 0);

Actually, no, it's this one:

static void cfq_put_request(struct request *rq)
{
        struct cfq_queue *cfqq = RQ_CFQQ(rq);

        if (cfqq) {
                const int rw = rq_data_dir(rq);

                BUG_ON(!cfqq->allocated[rw]);
                cfqq->allocated[rw]--;

Sorry for not providing this info in the original report.

>> [   33.949646] invalid opcode: 0000 [#1] SMP 
>> [   33.949646] last sysfs
>> file: /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.0/0000:06:01.0/host0/rport-0:0-1/target0:0:1/fc_transport/target0:0:1/node_name
>> [   33.949646] Modules linked in: dm_round_robin scsi_dh_emc sd_mod
>> crc_t10dif dm_multipath dm_mod scsi_dh uhci_hcd ehci_hcd
>> ide_pci_generic ata_generic qla2xxx mptspi mptscsih mptbase libata
>> scsi_transport_fc scsi_transport_spi piix scsi_tgt scsi_mod tg3 button
>> libphy ide_core usbcore nls_base thermal fan thermal_sys [last
>> unloaded: scsi_wait_scan]
>> [   33.949646] 
>> [   33.949646] Pid: 329, comm: kmpath_handlerd Not tainted
>> (2.6.32-trunk-686 #1) IBM BladeCenter HS20 -[884321Y]-
>> [   33.949646] EIP: 0060:[<c112c454>] EFLAGS: 00010046 CPU: 0
>> [   33.949646] EIP is at cfq_put_request+0x1c/0x4a
>> [   33.949646] EAX: 00000000 EBX: f6676e10 ECX: c112c438 EDX: 0000000d
>> [   33.949646] ESI: f6fd9700 EDI: f60194c0 EBP: 00000001 ESP: f64a3ed4
>> [   33.949646]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>> [   33.949646] Process kmpath_handlerd (pid: 329, ti=f64a2000
>> task=f64e8440 task.ti=f64a2000)
>> [   33.949646] Stack:
>> [   33.949646]  f6676e10 01282c4f c111bb19 c1122618 f60194c0 f6676e10
>> 00000292 c1122ad3
>> [   33.949646] <0> f607f70c f83842cb 00000000 f8383491 f607f610
>> f666bc00 f666bc00 f6676e10
>> [   33.949646] <0> 00000000 00000003 00000000 f607f600 f666bc00
>> f607f60c f8383761 00000000
>> [   33.949646] Call Trace:
>> [   33.949646]  [<c111bb19>] ? elv_put_request+0x10/0x11
>> [   33.949646]  [<c1122618>] ? __blk_put_request+0x60/0x8e
>> [   33.949646]  [<c1122ad3>] ? blk_put_request+0x1e/0x2e
>> [   33.949646]  [<f8383491>] ? send_trespass_cmd+0x21c/0x226
>> [scsi_dh_emc]
>> [   33.949646]  [<f8383761>] ? clariion_activate+0x3b/0xeb
>> [scsi_dh_emc]
>
> So best guess would be a reference counting error in the way scsi_dh_emc
> sends trespass commands.

I think this guess isn't so good anymore, given the above context.  But
I'm doing textual pattern matching only... :)

Thanks,
Feri.

>> [...]
>> And one more, where the beginning part is missing (I really wonder why
>> the management system behaves like this):
>> 
>> Begin: Mounting root file system ... Begin: Runn[   18.791487]
>> device-mapper: uevent: version 1.0.3
>> ing /scripts/loc[   18.828401] device-mapper: ioctl: 4.15.0-ioctl
>> (2009-04-01) initialised: dm-devel@redhat.com
>> al-top ... Begin[   18.889718] device-mapper: multipath: version 1.1.0
>> loaded
>> : Loading multipath modules ... [   18.940906] sd 0:0:0:0: emc:
>> detected Clariion CX3-40f, flags 0
>> Success: loaded [   18.979823] sd 0:0:0:0: emc: connected to SP A Port
>> 3 (bound, default SP B)
>> module dm-multip[   19.029770] sd 0:0:0:2: emc: detected Clariion
>> CX3-40f, flags 0
>> ath.
>> all Trace:
>> [   19.221341]  [<c111bb19>] ? elv_put_request+0x10/0x11
>> [   19.221341]  [<c1122618>] ? __blk_put_request+0x60/0x8e
>> [   19.221341]  [<c1122ad3>] ? blk_put_request+0x1e/0x2e
>> [   19.221341]  [<f8374491>] ? send_trespass_cmd+0x21c/0x226
>> [scsi_dh_emc]
>> [   19.221341]  [<c1259c36>] ? schedule+0x78f/0x7dc
>> [   19.221341]  [<f8374761>] ? clariion_activate+0x3b/0xeb
>> [scsi_dh_emc]
>> [   19.221341]  [<f83055f1>] ? scsi_dh_activate+0x6d/0x82 [scsi_dh]
>> [   19.221341]  [<f8340b8c>] ? activate_path+0x1d/0x118 [dm_multipath]
>> [   19.221341]  [<c1041677>] ? worker_thread+0x141/0x1bd
>> [   19.221341]  [<f8340b6f>] ? activate_path+0x0/0x118 [dm_multipath]
>> [   19.221341]  [<c10443b2>] ? autoremove_wake_function+0x0/0x2d
>> [   19.221341]  [<c1041536>] ? worker_thread+0x0/0x1bd
>> [   19.221341]  [<c1044180>] ? kthread+0x61/0x66
>> [   19.221341]  [<c104411f>] ? kthread+0x0/0x66
>> [   19.221341]  [<c1003d47>] ? kernel_thread_helper+0x7/0x10
>> [   19.221341] Code: 6b 49 c1 89 da 5b 5e e9 3b 13 f8 ff 5b 5e c3 56
>> 53 8b 70 5c 89 c3 85 f6 74 3c 8b 40 24 83 e0 01 8d 50 0c 8b 44 96 0c
>> 85 c0 75 04 <0f> 0b eb fe 48 89 44 96 0c 8b 43 58 8b 40 10 e8 4a 8f ff
>> ff 89 
>> [   19.221341] EIP: [<c112c454>] cfq_put_request+0x1c/0x4a SS:ESP
>> 0068:f64b3ed4
>> [   19.221341] ---[ end trace 2406ac42e6ebdd24 ]---
>> 
>> At least we have a the full stack trace now...  Can you perhaps
>> pinpoint the problem based on such fragmented information?  Please
>> find my kernel config below.
