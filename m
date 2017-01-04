From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] [SCSI] mpt3sas: add new driver supporting 12GB SAS
Date: Wed, 4 Jan 2017 16:52:14 +0300
Message-ID: <20170104135214.GC13702@mwanda>
References: <20170104133315.GA19973@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30789 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753836AbdADNyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2017 08:54:03 -0500
Content-Disposition: inline
In-Reply-To: <20170104133315.GA19973@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth.Reddy@lsi.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org

Oops...  This one is really old.  I didn't look carefully at it before I
hit send.  Sorry about that.

regards,
dan carpenter


On Wed, Jan 04, 2017 at 04:33:16PM +0300, Dan Carpenter wrote:
> Hello Sreekanth Reddy,
> 
> The patch f92363d12359: "[SCSI] mpt3sas: add new driver supporting
> 12GB SAS" from Nov 30, 2012, leads to the following static checker
> warning:
> 
> 	drivers/scsi/mpt3sas/mpt3sas_base.c:620 _base_display_event_data()
> 	warn: curly braces intended?
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c
>    610          case MPI2_EVENT_SAS_DISCOVERY:
>    611          {
>    612                  Mpi2EventDataSasDiscovery_t *event_data =
>    613                      (Mpi2EventDataSasDiscovery_t *)mpi_reply->EventData;
>    614                  pr_info(MPT3SAS_FMT "Discovery: (%s)", ioc->name,
>    615                      (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
>    616                      "start" : "stop");
>    617                  if (event_data->DiscoveryStatus)
>    618                          pr_info("discovery_status(0x%08x)",
>    619                              le32_to_cpu(event_data->DiscoveryStatus));
>    620                          pr_info("\n");
> 
> The indenting is messed up here and also this should be using pr_cont()
> because pr_info() will put a bunch of crap in the middle of the line.
> 
>    621                  return;
>    622          }
> 
> regards,
> dan carpenter
