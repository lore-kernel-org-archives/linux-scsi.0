From: PanBian <bianpan2016@163.com>
Subject: Re: scsi: hisi_sas: replace kfree with scsi_host_put
Date: Tue, 8 Aug 2017 23:12:28 +0800
Message-ID: <20170808151228.GA32235@bp>
References: <1502192263-12332-1-git-send-email-bianpan2016@163.com>
 <c39e1cef-5356-01b7-5316-10ba45f0bba8@huawei.com>
Reply-To: PanBian <bianpan2016@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c39e1cef-5356-01b7-5316-10ba45f0bba8@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linuxarm <linuxarm@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 08, 2017 at 03:56:22PM +0100, John Garry wrote:
> On 08/08/2017 12:37, Pan Bian wrote:
> >Return value of scsi_host_alloc() should be released with
> >scsi_host_put() rather than kfree().
> >
> >Signed-off-by: Pan Bian <bianpan2016@163.com>
> 
> We also have a kfree(shost) in newly added pci-based v3 driver which
> would need replacing for consistency.
> 
> But, apart from that, we seem to have a pre-existing issue in
> hisi_sas_shost_alloc_pci(), which is missing the shost clean-up for
> error path.
> 
> Let me know if you want me to take over this patch and fix up the
> other places.

Yes, of course.

> 
> John
> 

Thank you,
Pan Bian

> >---
> > drivers/scsi/hisi_sas/hisi_sas_main.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> >index 4022c3f..22d8922 100644
> >--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> >+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> >@@ -1825,7 +1825,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
> >
> > 	return shost;
> > err_out:
> >-	kfree(shost);
> >+	scsi_host_put(shost);
> > 	dev_err(dev, "shost alloc failed\n");
> > 	return NULL;
> > }
> >@@ -1916,7 +1916,7 @@ int hisi_sas_probe(struct platform_device *pdev,
> > 	scsi_remove_host(shost);
> > err_out_ha:
> > 	hisi_sas_free(hisi_hba);
> >-	kfree(shost);
> >+	scsi_host_put(shost);
> > 	return rc;
> > }
> > EXPORT_SYMBOL_GPL(hisi_sas_probe);
> >@@ -1931,7 +1931,7 @@ int hisi_sas_remove(struct platform_device *pdev)
> > 	sas_remove_host(sha->core.shost);
> >
> > 	hisi_sas_free(hisi_hba);
> >-	kfree(shost);
> >+	scsi_host_put(shost);
> > 	return 0;
> > }
> > EXPORT_SYMBOL_GPL(hisi_sas_remove);
> >
> 
> 
