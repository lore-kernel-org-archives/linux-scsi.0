From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2.6.13 14/14] sas-class: SCSI Host glue
Date: Fri, 09 Sep 2005 18:35:49 -0500
Message-ID: <1126308949.4799.54.camel@mulgrave>
References: <4321E5AB.5000100@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030985AbVIIXgx@vger.kernel.org>
In-Reply-To: <4321E5AB.5000100@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-09-09 at 15:42 -0400, Luben Tuikov wrote:
> +static const struct scsi_host_template sas_host_template = {
> +       .module = THIS_MODULE,
> +       /* .name is initialized */
> +       .name = "",
> +       .queuecommand = sas_queuecommand,
> +       .eh_strategy_handler = sas_scsi_recover_host,
> +       .eh_timed_out = sas_scsi_timed_out,
> +       .slave_alloc = sas_slave_alloc,
> +       .slave_configure = sas_slave_configure,
> +       .slave_destroy = sas_slave_destroy,
> +       .change_queue_depth = sas_change_queue_depth,
> +       .change_queue_type = sas_change_queue_type,
> +       .bios_param = sas_bios_param,
> +       /* .can_queue is initialized */
> +       .this_id = -1,
> +       .sg_tablesize = SG_ALL,
> +       .max_sectors = SCSI_DEFAULT_MAX_SECTORS,
> +       /* .cmd_per_lun is initilized to .can_queue */
> +       .use_clustering = ENABLE_CLUSTERING,
> +};

You can't do something like this and be generic.  You intercept all of
the slave_* calls and try to provide the template.

This has produced a class that might wrapper nicely around the aic94xx
but it won't attach nicely to any other SAS driver.

You can't decide what table size and alignment your drivers are going to
have because not all will conform to them.  I already know that SATA (ex
ATA) vendors are getting into the SAS market ... they have particularly
weird SG allocation and alignment requirements for some of their stuff.

To be an actual transport class, aside from actually using the transport
class infrastructure, the code actually has to provide common routines
that a class of drivers can use.

There's already an embryonic SAS class working its way through the SCSI
list.  Could you look at enhancing that instead of trying to produce a
competing class?

James
