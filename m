From: Grant Grundler <grundler@google.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
	controller
Date: Fri, 12 Jun 2009 08:08:35 -0700
Message-ID: <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
	 <4A31319C.605@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:59765 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZFLPIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 11:08:40 -0400
Received: from spaceape10.eur.corp.google.com (spaceape10.eur.corp.google.com [172.28.16.144])
	by smtp-out.google.com with ESMTP id n5CF8ck6030216
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 16:08:38 +0100
Received: from qyk4 (qyk4.prod.google.com [10.241.83.132])
	by spaceape10.eur.corp.google.com with ESMTP id n5CF8HwK007540
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 08:08:36 -0700
Received: by qyk4 with SMTP id 4so3193709qyk.20
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 08:08:36 -0700 (PDT)
In-Reply-To: <4A31319C.605@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, gregkh@suse.de

On Thu, Jun 11, 2009 at 9:32 AM, Brian King<brking@linux.vnet.ibm.com> =
wrote:
> Anil Ravindranath wrote:
=2E...
>> +static void pmcraid_init_res_table(struct pmcraid_cmd *);
>> +static void pmcraid_set_supported_devs(struct pmcraid_cmd *);
>> +static void pmcraid_fail_outstanding_cmds(struct pmcraid_instance *=
);
>
> Its generally suggested to structure your driver such that you minimi=
ze,
> if not avoid having to declare prototypes. Not sure if you can move s=
ome functions
> around to reduce the number of prototypes here.

Anil,
I was thinking the same thing that Brian mentions. Basically,
he's saying order the function declarations such that forward
declarations of functions are not needed.


>> +static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
>> +{
>> + =C2=A0 =C2=A0 struct pmcraid_resource_entry *temp, *res =3D NULL;
>> + =C2=A0 =C2=A0 struct pmcraid_instance *pinstance;
>> + =C2=A0 =C2=A0 u8 target, bus, lun;
>> + =C2=A0 =C2=A0 unsigned long lock_flags;
>> + =C2=A0 =C2=A0 int rc =3D -ENXIO;
>> +
>> + =C2=A0 =C2=A0 pinstance =3D (struct pmcraid_instance *)scsi_dev->h=
ost->hostdata;
>> +
>> + =C2=A0 =C2=A0 /* Driver exposes VSET and GSCSI resources only; all=
 other device types
>> + =C2=A0 =C2=A0 =C2=A0* are not exposed. Resource list is synchroniz=
ed using resource lock
>> + =C2=A0 =C2=A0 =C2=A0* so any traversal or modifications to the lis=
t should be done inside
>> + =C2=A0 =C2=A0 =C2=A0* this lock
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 spin_lock_irqsave(&pinstance->resource_lock, lock_fl=
ags);
>> + =C2=A0 =C2=A0 list_for_each_entry(temp, &pinstance->used_res_q, qu=
eue) {
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* do not expose VSETs w=
ith order-ids >=3D 240 */
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (RES_IS_VSET(temp->cf=
g_entry)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 target =3D temp->cfg_entry.unique_flags1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (target >=3D PMCRAID_MAX_VSET_TARGETS)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 bus =3D PMCRAID_VSET_BUS_ID;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 lun =3D 0;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (RES_IS_GSCSI(=
temp->cfg_entry)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 target =3D RES_TARGET(temp->cfg_entry.resource_address);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 bus =3D PMCRAID_PHYS_BUS_ID;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 lun =3D RES_LUN(temp->cfg_entry.resource_address);
>
> I assume this means this adapter only supports single byte LUNs...

ISTR, SCSI-3 spec only defines 5-bits for the LUN field...but my SCSI-f=
oo
pretty old and I might misremember. It was easy to find this reference:
    http://en.wikipedia.org/wiki/SCSI_Read_Commands

I'm sure there something better from t10.org but everything requires
a login now and I'm sure someone here will just know this.

=2E..
>> +/* writing =C2=A0into a 64-bit iomemory address */
>> +static inline void write64(unsigned long val, void __iomem *addr)
>> +{
>> + =C2=A0 =C2=A0 /* write MSBytes first as writing to LSBytes starts =
IOA DMA. IOARCB
>> + =C2=A0 =C2=A0 =C2=A0* address is always 32-bit as it allocated by =
pci_alloc_consistent
>> + =C2=A0 =C2=A0 =C2=A0* hence first write is not required
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 /*iowrite32((u32) (val >> 32), (addr + 4)); */
>> + =C2=A0 =C2=A0 iowrite32(le32_to_cpu(val), addr);
>
> Wrapper functions like this that simply wrapper an existing Linux API
> are generally frowned upon, just call the function directly.
> Additionally, shouldn't this be calling writel instead? That's what a=
lmost every
> SCSI driver does.

Use writeq() or iowrite64() instead. That's a 64-bit MMIO write.

Two additional things bug me about this function:
1) Assumes pci_alloc_consistent() returns 32-bit DMA addresses.
   That assumption is only guaranteed if the driver calls
pci_set_consistent_dma_mask()
   with a 32-bit mask (which happens to be the current default). This
driver does call
   pci_set_dma_mask() but does not call pci_set_consistent_dma_mask().
   It should. New PCI-e device driver should be setting this to
64-bits and using
   writeq() to push the address.

2) Comments further down claim write64() isn't actually writing 64-bits=
=2E
    More bad assumption. Please remove those comments and use
    writeq() instead.  Assumptions like this will burn us later when th=
e
    code or behavior is changed and we miss something like this.


>> +static void _pmcraid_fire_command(struct pmcraid_cmd *cmd, u8 lock)
>> +{
>> + =C2=A0 =C2=A0 struct pmcraid_instance *pinstance =3D cmd->drv_inst=
;
>> + =C2=A0 =C2=A0 unsigned long lock_flags;
>> +
>> + =C2=A0 =C2=A0 /* Add this command block to pending cmd pool. We do=
 this prior to
>> + =C2=A0 =C2=A0 =C2=A0* writting IOARCB to ioarrin because IOA might=
 complete the command
>> + =C2=A0 =C2=A0 =C2=A0* by the time we are about to add it to the li=
st. Response handler
>> + =C2=A0 =C2=A0 =C2=A0* (isr/tasklet) looks for cmb block in the pen=
ding pending list.
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 spin_lock_irqsave(&pinstance->pending_pool_lock, loc=
k_flags);
>> + =C2=A0 =C2=A0 list_add_tail(&cmd->free_list, &pinstance->pending_c=
md_pool);
>> + =C2=A0 =C2=A0 atomic_inc(&pinstance->outstanding_cmds);

atomic_inc doesn't need to be lock protected. This can be moved outside
the critical code (between lock/unlock).

>> + =C2=A0 =C2=A0 spin_unlock_irqrestore(&pinstance->pending_pool_lock=
, lock_flags);
>> +
>> + =C2=A0 =C2=A0 /* Mulitple paths (IO path, control path) may be sub=
mitting IOARCBs,
>> + =C2=A0 =C2=A0 =C2=A0* hence it is necessary to protect writes to I=
OA's ioarrin register.
>> + =C2=A0 =C2=A0 =C2=A0* All writes to IOA ioarrin are synchronized w=
ith host_lock
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 if (lock)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock_irqsave(pinsta=
nce->host->host_lock,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pinstance->host_lock_flags);
>> +
>> + =C2=A0 =C2=A0 /* apply memory barrier */
>> + =C2=A0 =C2=A0 mb();
>> + =C2=A0 =C2=A0 /* driver writes lower 32-bit value of IOARCB addres=
s only */
>> + =C2=A0 =C2=A0 write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinstan=
ce->ioarrin);
>> +
>> + =C2=A0 =C2=A0 if (lock)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(p=
instance->host->host_lock,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pinstance->h=
ost_lock_flags);
>
> Any way to get rid of this lock flag getting passed in?

And I believe due to spinlock/unlock, the mb() is not needed.
Spin locks imply memory barriers.


>> +static void pmcraid_start_bist(struct pmcraid_cmd *cmd)
>> +{
>> + =C2=A0 =C2=A0 struct pmcraid_instance *pinstance =3D cmd->drv_inst=
;
>> +
>> + =C2=A0 =C2=A0 /* proceed with bist and wait for 2 seconds */
>> + =C2=A0 =C2=A0 pci_block_user_cfg_access(pinstance->pdev);
>> + =C2=A0 =C2=A0 iowrite32(DOORBELL_IOA_START_BIST,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pinstance->int_regs.host=
_ioa_interrupt_reg);
>
> Are you actually running BIST here or some other reset? BIST is typic=
ally
> initiated through PCI config space rather than memory space.

This might be something other than the PCI Config BIST.

And the iowrite32(host_ioa_interrupt_reg) needs to be followed by
a pci config read to flush the MMIO write. iowrite32() is a posted writ=
e.

=2E..
>> +static void pmcraid_initiate_reset(struct pmcraid_instance *pinstan=
ce)
>> +{
>> + =C2=A0 =C2=A0 struct pmcraid_cmd *cmd;
>> + =C2=A0 =C2=A0 unsigned long lock_flags;
>> +
>> + =C2=A0 =C2=A0 /* If the reset is already in progress, just return,=
 otherwise start
>> + =C2=A0 =C2=A0 =C2=A0* reset sequence and return
>> + =C2=A0 =C2=A0 =C2=A0*/
>> + =C2=A0 =C2=A0 spin_lock_irqsave(&pinstance->reset_lock, lock_flags=
);
>> + =C2=A0 =C2=A0 if (pinstance->ioa_reset_in_progress) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&=
pinstance->reset_lock, lock_flags);
>> + =C2=A0 =C2=A0 } else {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock_irqrestore(&=
pinstance->reset_lock, lock_flags);
>
> This looks wrong. If you need to hold the lock to check ioa_reset_in_=
progress,
> don't you need to hold it through the next couple of lines of code wh=
en you
> initiate the reset? How do you know the state doesn't change while yo=
u are
> executing the next few lines of code?

I agree this looks wrong.
He needs to set ioa_reset_in_progress in the "else" case and can then
release the spinlock.


>> +
>> + =C2=A0 =C2=A0 /* If this was a SCSI read/write command keep count =
of errors */
>> + =C2=A0 =C2=A0 if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) =3D=3D SCSI_REA=
D_CMD)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 res->read_failures++;
>> + =C2=A0 =C2=A0 else if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) =3D=3D SCS=
I_WRITE_CMD)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 res->write_failures++;
>
> These are both getting incremented without locks, which could cause t=
hem
> to get corrupted.

atomic_inc() should be sufficient here.
(I didn't check the locking...assuming Brian is correct.)



>> +/* Maximum number of adapters supported by current version of the d=
river */
>> +#define PMCRAID_MAX_ADAPTERS =C2=A0 =C2=A0 =C2=A0 =C2=A0 32
>
> Why is there a limit on the max adapters supported?

Because of this code I think:
+DECLARE_BITMAP(pmcraid_minor, PMCRAID_MAX_ADAPTERS);
=2E..
+       error =3D alloc_chrdev_region(&dev, 0,
+                                   PMCRAID_MAX_ADAPTERS,
+                                   PMCRAID_DEVFILE);

I don't know offhand how to avoid this. Suggestions?


thanks,
grant
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
