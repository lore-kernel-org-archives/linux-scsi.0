From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Mon, 2 Mar 2009 15:32:35 +0900
Message-ID: <20090302153246A.fujita.tomonori@lab.ntt.co.jp>
References: <20090227230927.GA21377@roadking.ldev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:50552 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbZCBGdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Mar 2009 01:33:15 -0500
In-Reply-To: <20090227230927.GA21377@roadking.ldev.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mike.miller@hp.com
Cc: jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com, iss.sbteam@hp.com

On Fri, 27 Feb 2009 17:09:27 -0600
Mike Miller <mike.miller@hp.com> wrote:

> This patch is a scsi based driver for the HP Smart Array controllers. It
> will eventually replace the block driver called cciss. At his time there is

Superb! This is what I've been waiting for.


> +/*define how many times we will try a command because of bus resets */
> +#define MAX_CMD_RETRIES 3
> +#define MAX_CTLR	32
> +
> +/* Embedded module documentation macros - see modules.h */
> +MODULE_AUTHOR("Hewlett-Packard Company");
> +MODULE_DESCRIPTION("Driver for HP Smart Array Controller version 1.0.0");
> +MODULE_SUPPORTED_DEVICE("HP Smart Array Controllers");
> +MODULE_VERSION("1.0.0");
> +MODULE_LICENSE("GPL");
> +
> +static int allow_unknown_smartarray;
> +module_param(allow_unknown_smartarray, int, S_IRUGO|S_IWUSR);
> +MODULE_PARM_DESC(allow_unknown_smartarray,
> +		"Allow driver to load on unknown HP Smart Array hardware");
> +
> +/* define the PCI info for the cards we can control */
> +static const struct pci_device_id hpsa_pci_device_id[] = {
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3223},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x3234},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSC,     0x103C, 0x323D},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3241},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3243},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3245},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3247},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324a},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324b},
> +	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,             PCI_ANY_ID, PCI_ANY_ID,
> +		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
> +	{0,}
> +};
> +
> +MODULE_DEVICE_TABLE(pci, hpsa_pci_device_id);
> +
> +/*  board_id = Subsystem Device ID & Vendor ID
> + *  product = Marketing Name for the board
> + *  access = Address of the struct of function pointers
> + */
> +static struct board_type products[] = {
> +	{0x3223103C, "Smart Array P800", &SA5_access},
> +	{0x3234103C, "Smart Array P400", &SA5_access},
> +	{0x323d103c, "Smart Array P700M", &SA5_access},
> +	{0x3241103C, "Smart Array P212", &SA5_access},
> +	{0x3243103C, "Smart Array P410", &SA5_access},
> +	{0x3245103C, "Smart Array P410i", &SA5_access},
> +	{0x3247103C, "Smart Array P411", &SA5_access},
> +	{0x3249103C, "Smart Array P812", &SA5_access},
> +	{0x324a103C, "Smart Array P712m", &SA5_access},
> +	{0x324b103C, "Smart Array P711m", &SA5_access},
> +	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
> +};
> +
> +static struct ctlr_info *hba[MAX_CTLR];

Do we really need this static array? Allocating struct ctlr_info
dynamically is fine?


> +static irqreturn_t do_hpsa_intr(int irq, void *dev_id);
> +static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
> +static void start_io(struct ctlr_info *h);
> +static int sendcmd(__u8 cmd, struct ctlr_info *h, void *buff, size_t size,
> +		   __u8 page_code, unsigned char *scsi3addr, int cmd_type);
> +
> +#ifdef CONFIG_COMPAT
> +static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
> +#endif
> +
> +static void cmd_free(struct ctlr_info *h, struct CommandList_struct *c);
> +static void cmd_special_free(struct ctlr_info *h, struct CommandList_struct *c);
> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h);
> +static struct CommandList_struct *cmd_special_alloc(struct ctlr_info *h);
> +
> +static int hpsa_scsi_proc_info(
> +		struct Scsi_Host *sh,
> +		char *buffer, /* data buffer */
> +		char **start, 	   /* where data in buffer starts */
> +		off_t offset,	   /* offset from start of imaginary file */
> +		int length, 	   /* length of data in buffer */
> +		int func);	   /* 0 == read, 1 == write */
> +
> +static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
> +		void (*done)(struct scsi_cmnd *));
> +
> +static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
> +
> +static struct scsi_host_template hpsa_driver_template = {
> +	.module			= THIS_MODULE,
> +	.name			= "hpsa",
> +	.proc_name		= "hpsa",
> +	.proc_info		= hpsa_scsi_proc_info,
> +	.queuecommand		= hpsa_scsi_queue_command,
> +	.can_queue		= 512,
> +	.this_id		= -1,
> +	.sg_tablesize		= MAXSGENTRIES,

MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
better to enlarge this for better performance?


> +	.cmd_per_lun		= 512,
> +	.use_clustering		= DISABLE_CLUSTERING,

Why can we use ENABLE_CLUSTERING here? We would get the better
performance with ENABLE_CLUSTERING.


> +	.eh_device_reset_handler = hpsa_eh_device_reset_handler,
> +	.ioctl			= hpsa_ioctl,
> +#ifdef CONFIG_COMPAT
> +	.compat_ioctl		= hpsa_compat_ioctl,
> +#endif
> +};
> +
> +/* Enqueuing and dequeuing functions for cmdlists. */
> +static inline void addQ(struct hlist_head *list, struct CommandList_struct *c)
> +{
> +	hlist_add_head(&c->list, list);
> +}
> +
> +static inline void removeQ(struct CommandList_struct *c)
> +{
> +	if (WARN_ON(hlist_unhashed(&c->list)))
> +		return;
> +	hlist_del_init(&c->list);
> +}
> +
> +static inline int bit_is_set(__u8 bitarray[], int bit)
> +{
> +	return bitarray[bit >> 3] & (1 << (bit & 0x07));
> +}
> +
> +static inline void set_bit_in_array(__u8 bitarray[], int bit)
> +{
> +	bitarray[bit >> 3] |= (1 << (bit & 0x07));
> +}

Can not we use the standard bit operation functions instead?


> +/* hpsa_scatter_gather takes a struct scsi_cmnd, (cmd), and does the pci
> +   dma mapping  and fills in the scatter gather entries of the
> +   hpsa command, cp. */
> +
> +static void hpsa_scatter_gather(struct pci_dev *pdev,
> +		struct CommandList_struct *cp,
> +		struct scsi_cmnd *cmd)
> +{
> +	unsigned int len;
> +	struct scatterlist *sg;
> +	__u64 addr64;
> +	int use_sg, i;
> +
> +	BUG_ON(scsi_sg_count(cmd) > MAXSGENTRIES);
> +
> +	use_sg = scsi_dma_map(cmd);
> +	if (!use_sg)
> +		goto sglist_finished;

We need to handle dma mapping failure here; scsi_dma_map could fail.


> +	scsi_for_each_sg(cmd, sg, use_sg, i) {
> +		addr64 = (__u64) sg_dma_address(sg);
> +		len  = sg_dma_len(sg);
> +		cp->SG[i].Addr.lower =
> +			(__u32) (addr64 & (__u64) 0x00000000FFFFFFFF);
> +		cp->SG[i].Addr.upper =
> +			(__u32) ((addr64 >> 32) & (__u64) 0x00000000FFFFFFFF);
> +		cp->SG[i].Len = len;
> +		cp->SG[i].Ext = 0;  /* we are not chaining */
> +	}
> +
> +sglist_finished:
> +
> +	cp->Header.SGList = (__u8) use_sg;   /* no. SGs contig in this cmd */
> +	cp->Header.SGTotal = (__u16) use_sg; /* total sgs in this cmd list */
> +	return;
> +}
> +
> +
> +static int hpsa_scsi_queue_command(struct scsi_cmnd *cmd,
> +	void (*done)(struct scsi_cmnd *))
> +{
> +	struct ctlr_info *h;
> +	int rc;
> +	unsigned char scsi3addr[8];
> +	struct CommandList_struct *cp;
> +	unsigned long flags;
> +
> +	/* Get the ptr to our adapter structure (hba[i]) out of cmd->host. */
> +	h = (struct ctlr_info *) cmd->device->host->hostdata[0];

Let's use shost_priv().


> +	rc = lookup_scsi3addr(h, cmd->device->channel, cmd->device->id,
> +			cmd->device->lun, scsi3addr);
> +	if (rc != 0) {
> +		/* the scsi nexus does not match any that we presented... */
> +		/* pretend to mid layer that we got selection timeout */
> +		cmd->result = DID_NO_CONNECT << 16;
> +		done(cmd);
> +		/* we might want to think about registering controller itself
> +		   as a processor device on the bus so sg binds to it. */
> +		return 0;
> +	}
> +
> +	/* Ok, we have a reasonable scsi nexus, so send the cmd down, and
> +	   see what the device thinks of it. */
> +
> +	/* Need a lock as this is being allocated from the pool */
> +	spin_lock_irqsave(&h->lock, flags);
> +	cp = cmd_alloc(h);
> +	spin_unlock_irqrestore(&h->lock, flags);
> +	if (cp == NULL) {			/* trouble... */

We run out of commands here. Returning SCSI_MLQUEUE_HOST_BUSY is
appropriate here, I think.

But if we allocate shost->can_queue at startup, we can't run out of
commands.


> +/* Get us a file in /proc/hpsa that says something about each controller.
> + * Create /proc/hpsa if it doesn't exist yet.  */
> +static void __devinit hpsa_procinit(struct ctlr_info *h)
> +{
> +	struct proc_dir_entry *pde;
> +
> +	if (proc_hpsa == NULL)
> +		proc_hpsa = proc_mkdir("driver/hpsa", NULL);
> +	if (!proc_hpsa)
> +		return;
> +	pde = proc_create_data(h->devname, S_IRUSR | S_IRGRP | S_IROTH,
> +				     proc_hpsa, &hpsa_proc_fops, h);
> +}
> +#endif				/* CONFIG_PROC_FS */

We really need this? Creating something under /proc is not good. Using
/sys/class/scsi_host/ is the proper way. If we remove the overlap
between hpsa and cciss, we can do the proper way, I think.


> +/*
> + * For operations that cannot sleep, a command block is allocated at init,
> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
> + * which ones are free or in use.  Lock must be held when calling this.
> + * cmd_free() is the complement.
> + */
> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
> +{
> +	struct CommandList_struct *c;
> +	int i;
> +	union u64bit temp64;
> +	dma_addr_t cmd_dma_handle, err_dma_handle;
> +
> +	do {
> +		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> +		if (i == h->nr_cmds)
> +			return NULL;
> +	} while (test_and_set_bit
> +		 (i & (BITS_PER_LONG - 1),
> +		  h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);

Using bitmap to manage free commands looks too complicated a bit to
me. Can we just use lists for command management?
