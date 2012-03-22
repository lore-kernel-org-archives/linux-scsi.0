From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [libsas PATCH v12 10/11] scsi, sd: limit the scope of the async
 probe domain
Date: Thu, 22 Mar 2012 10:20:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1203221016580.1310-100000@iolanthe.rowland.org>
References: <20120322063245.22036.78652.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120322063245.22036.78652.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 21 Mar 2012, Dan Williams wrote:

> sd injects and synchronizes probe work on the global kernel-wide domain.
> This runs into conflict with PM that wants to perform resume actions in
> async context:

...

> Provide a 'scsi_sd_probe_domain' so that async probe actions actions can
> be flushed without regard for the state of PM, and allow for the resume
> path to handle devices that have transitioned from SDEV_QUIESCE to
> SDEV_DEL prior to resume.

> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -393,6 +393,10 @@ static inline int scsi_autopm_get_device(struct scsi_device *d) { return 0; }
>  static inline void scsi_autopm_put_device(struct scsi_device *d) {}
>  #endif /* CONFIG_PM_RUNTIME */
>  
> +#if IS_ENABLED(CONFIG_PM) || IS_ENABLED(CONFIG_BLK_DEV_SD)
> +extern struct list_head scsi_sd_probe_domain;
> +#endif
> +

This doesn't need to be provided to drivers outside the SCSI core, so 
the declaration doesn't need to be in include/scsi.  I'd move it to 
drivers/scsi/scsi_priv.h.

Apart from that,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

