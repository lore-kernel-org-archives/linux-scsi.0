From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] move all procfs code to scsi_proc.c
Date: Sat, 16 Nov 2002 12:01:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021116120148.A6799@eng2.beaverton.ibm.com>
References: <20021116200249.A23459@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021116200249.A23459@lst.de>; from hch@lst.de on Sat, Nov 16, 2002 at 08:02:49PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, Nov 16, 2002 at 08:02:49PM +0100, Christoph Hellwig wrote:

> -extern void proc_print_scsidevice(Scsi_Device *, char *, int *, int);
> +#ifdef CONFIG_PROC_FS
> +extern int scsi_init_procfs(void);
> +extern void scsi_exit_procfs(void);
> +
> +extern void scsi_proc_host_add(struct Scsi_Host *);
> +extern void scsi_proc_host_rm(struct Scsi_Host *);
> +
>  extern struct proc_dir_entry *proc_scsi;
> +#else
> +static inline int scsi_init_procfs(void) { return 0; };
> +static inline void scsi_exit_procfs(void) { };
> +
> +static inline void scsi_proc_host_add(struct Scsi_Host *);
> +static inline void scsi_proc_host_rm(struct Scsi_Host *);
> +#endif /* CONFIG_PROC_FS */

Where are the calls to scsi_init_procfs and scsi_exit_procfs?

-- Patrick Mansfield
