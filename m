From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add	block/blk-map.c:blk_rq_map_kern_sg()
 usage
Date: Thu, 30 Apr 2009 12:37:27 +0300
Message-ID: <49F97157.4070901@panasas.com>
References: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010107000305090505060104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:23222 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754031AbZD3Jjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Apr 2009 05:39:46 -0400
In-Reply-To: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>

This is a multi-part message in MIME format.
--------------010107000305090505060104
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 04/29/2009 03:43 AM, Nicholas A. Bellinger wrote:
> Greetings all,
> 
> This patch adds a new version of pscsi_map_task_SG() for the Linux/SCSI
> passthrough subsystem plugin for target_core_mod v3.0 that uses Tejun's blk-map
> patches on v2.6.30-rcX from git.kernel.org/pub/scm/linux/kernel/tj/misc.git blk-map.
> This patch adds a LINUX_USE_NEW_BLK_MAP define to allow both blk_rq_map_kern_sg() and
> legacy, non blk_rq_map_kern_sg() operation (with some limitiations with the latter) to
> function.
> 
> Once Tejun's patches for block/blk-map.c:blk_rq_map_kern_sg() have been included
> upstream, the legacy pscsi_map_task_SG() will be removed and blk-map will become
> the preferred method for accessing struct scatterlist -> struct scsi_device for
> SCSI target operations.  For now, I have created a blk-map branch in lio-core-2.6.git with
> LINUX_USE_NEW_BLK_MAP=1 and left LINUX_USE_NEW_BLK_MAP=0 in branch master.
> 
> This patch also updates pscsi_map_task_non_SG()'s usage of blk_rq_map_kern(), whos
> parameters have also been simplified in Tejun's patches.  It has been tested with
> lio-core-2.6.git branch master and blk-map and tested on v2.6.30-rc3 x86 32-bit
> HVM. The lio-core-2.6.git tree can be found at: 
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> 
> So far, using Tejun's new code with LINUX_USE_NEW_BLK_MAP=1 is passing badblocks from
> target_core_Mod/pSCSI exported Vmware mpt-fusion virtual SCSI HBA of TYPE_DISK.  Both the
> ConfigFS 'file-descriptor' method and 'SCSI HCTL reference' method for accessing
> struct scsi_device have been tested and are working with lio-core-2.6.git blk-map.
> 
> Currently *without* the blk-map patches on v2.6.30-rc3, is target_core_mod/pSCSI export is
> limited to TYPE_DISK and TYPE_ROM that reference a struct block_device using the ConfigFS
> 'file descriptor' method.  This is because bio_add_page() expects struct block_device to be

Better use bio_add_pc_page(). bio_add_page is only meant for fs requests.

> each struct bio associated with the struct request w/o Tejun's blk_rq_map_kern_sg().
> 
> Thanks Tejun for this patch series!  Things have been stable so far and I hope to try some
> 'bare-metal' and IOV enabled Linux/SCSI target exports using this patch series, along with validating
> blk-map on some non TYPE_DISK exports using target_core_mod/pSCSI.  I believe you intend this series for
> v2.6.31 correct..? 
> 
> Boaz, have you had a chance to port your stuff over to this yet..?  Other comments..?
> 

No. As I said, these patches were not good for me. I do not have scatterlist at all.
I have a pre-made bio, both from filesystem and a block device. So my needs are different.

Please note that the patches as last sent, were not good in my opinion, for regressing on
some robustness and performance issues.

There might be another solution for you, BTW. I'll be reposting a James Bottomley's
patch in 1-2 days that makes blk_rq_map_kern() append the buffers it receives instead
of only supporting a single call. So you can allocate the request and call blk_rq_map_kern()
in a loop for-each-sg. The bad thing with this is that the biovec inside will be allocated
multiple times, jumping from small pools to bigger ones. If only there was a way to specify
a pre-allocated bio-size.

Patch is attached for convenience

> --nab
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/MCONFIG_TARGET      |    1 +
>  drivers/target/Makefile            |    4 ++-
>  drivers/target/target_core_pscsi.c |   49 ++++++++++++++++++++++++++++++++++-
>  3 files changed, 51 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/MCONFIG_TARGET b/drivers/target/MCONFIG_TARGET
> index 8023deb..96541c4 100644
> --- a/drivers/target/MCONFIG_TARGET
> +++ b/drivers/target/MCONFIG_TARGET
> @@ -22,3 +22,4 @@ LINUX_FILEIO ?= 1
>  LINUX_VPD_PAGE_CHECK?=1
>  
>  LIO_TARGET_CONFIGFS?=1
> +LINUX_USE_NEW_BLK_MAP?=0
> diff --git a/drivers/target/Makefile b/drivers/target/Makefile
> index 47fef07..a19490d 100644
> --- a/drivers/target/Makefile
> +++ b/drivers/target/Makefile
> @@ -73,7 +73,9 @@ endif
>  ifeq ($(LINUX_SCSI_MEDIA_ROM), 1)
>  EXTRA_CFLAGS += -DLINUX_SCSI_MEDIA_ROM
>  endif
> -
> +ifeq ($(LINUX_USE_NEW_BLK_MAP), 1)
> +EXTRA_CFLAGS += -DLINUX_USE_NEW_BLK_MAP
> +endif
>  ifeq ($(DEBUG_DEV), 1)
>  EXTRA_CFLAGS += -DDEBUG_DEV
>  endif
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 0962563..0edcb9a 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -518,7 +518,12 @@ se_device_t *pscsi_create_virtdevice(
>  				" parameter\n");
>  		return NULL;
>  	}
> -
> +#ifndef LINUX_USE_NEW_BLK_MAP
> +	printk(KERN_ERR "Sorry, when running on >= v2.6.30 w/o blk-map branch"
> +		" you need to use the ConfigFS file descriptor method for"
> +		" accessing Linux/SCSI passthrough storage objects\n");
> +	return -EINVAL;
> +#endif
>  	spin_lock_irq(sh->host_lock);
>  	list_for_each_entry(sd, &sh->__devices, siblings) {
>  		if (!(pdv->pdv_channel_id == sd->channel) ||
> @@ -1269,6 +1274,39 @@ static inline struct bio *pscsi_get_bio(pscsi_dev_virt_t *pdv, int sg_num)
>  #define DEBUG_PSCSI(x...)
>  #endif
>  
> +#ifdef LINUX_USE_NEW_BLK_MAP

As I understand, you have a full Linux tree, at the git above.
The LINUX_USE_NEW_BLK_MAP define is not nice. And only causes more work
for you.

You leave master branch code based on current Kernel.

Then at blk-map branch you apply the correct lio patches together with Tejun's
at the proper places. After the fixture or change you are looking for. As if
lio was in kernel and this is the proper propagation of patches.

If you do this because of an out-of-tree compilation support, then here
too, you keep two branches, easily rebase two chains of patches, and provide
a tar-ball for the kernel in question. (git-web just does that for you
automatically.)

Because look, as long as you have LINUX_USE_NEW_BLK_MAP usage (in any branch)
then the code is not acceptable into mainline, and is just an experiment.

> +
> +/*	pscsi_map_task_SG()
> + *
> + *	This function uses the new struct scatterlist-> struct request mapping
> + *      from git.kernel.org/pub/scm/linux/kernel/tj/misc.git blk-map
> + *
> + *	This code is not upstream yet, so lio-core-2.6.git now has a blk-map
> + *	branch until this happens..
> + */
> +int pscsi_map_task_SG(se_task_t *task)
> +{
> +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	struct request *rq = pt->pscsi_req;
> +	int ret;
> +	/*
> +	 * For SCF_SCSI_DATA_SG_IO_CDB, use block/blk-map.c:blk_rq_map_kern_sg()
> +	 * for mapping struct scatterlist to struct request.  Thanks Tejun!
> +	 */
> +	ret = blk_rq_map_kern_sg(rq, task->task_sg, task->task_sg_num,
> +			GFP_KERNEL);
> +	if (ret != 0) {
> +		printk(KERN_ERR "blk_rq_map_kern_sg() failed for rq: %p"
> +				" task_sg: %p task_sg_num: %u\n",
> +			rq, task->task_sg, task->task_sg_num);
> +		return -1;
> +	}
> +
> +	return task->task_sg_num;
> +}
> +
> +#else
> +
>  /*      pscsi_map_task_SG():
>   *
>   *
> @@ -1376,6 +1414,9 @@ fail:
>  	return ret;
>  }
>  
> +#endif /* LINUX_USE_NEW_BLK_MAP */
> +
> +
>  /*	pscsi_map_task_non_SG():
>   *
>   *
> @@ -1389,10 +1430,14 @@ int pscsi_map_task_non_SG(se_task_t *task)
>  
>  	if (!task->task_size)
>  		return 0;
> -
> +#ifdef LINUX_USE_NEW_BLK_MAP

source code is not a version management system, Use git for that

> +	ret = blk_rq_map_kern(pt->pscsi_req, T_TASK(cmd)->t_task_buf,
> +			task->task_size, GFP_KERNEL);
> +#else
>  	ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
>  			pt->pscsi_req, T_TASK(cmd)->t_task_buf,
>  			task->task_size, GFP_KERNEL);
> +#endif
>  	if (ret < 0) {
>  		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
>  		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;


Cheers
Boaz

--------------010107000305090505060104
Content-Type: text/plain;
 name="0001-allow-blk_rq_map_kern-to-append-to-requests.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="0001-allow-blk_rq_map_kern-to-append-to-requests.patch"

RnJvbSAyOTgxZjliNzNlNzA2NzlkNDczNzA2OTg0YWQxMjk1YzY3NDVjNGJkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKYW1lcyBCb3R0b21sZXkgPEphbWVzLkJvdHRvbWxl
eUBIYW5zZW5QYXJ0bmVyc2hpcC5jb20+CkRhdGU6IE1vbiwgMTYgTWFyIDIwMDkgMTU6NDY6
NTMgKzAyMDAKU3ViamVjdDogW1BBVENIXSBhbGxvdyBibGtfcnFfbWFwX2tlcm4gdG8gYXBw
ZW5kIHRvIHJlcXVlc3RzCgpVc2UgYmxrX3JxX2FwcGVuZF9iaW8oKSBpbnRlcm5hbGx5IGlu
c3RlYWQgb2YgYmxrX3JxX2Jpb19wcmVwKCkKc28gYmxrX3JxX21hcF9rZXJuIGNhbiBiZSBj
YWxsZWQgbXVsdGlwbGUgdGltZXMsIHRvIG1hcCBtdWx0aXBsZQpidWZmZXJzLgoKVGhpcyBp
cyBpbiB0aGUgZWZmb3J0IHRvIHVuLWV4cG9ydCBibGtfcnFfYXBwZW5kX2JpbygpCgpTaWdu
ZWQtb2ZmLWJ5OiBCb2F6IEhhcnJvc2ggPGJoYXJyb3NoQHBhbmFzYXMuY29tPgotLS0KIGJs
b2NrL2Jsay1tYXAuYyB8ICAgMTIgKysrKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYmxvY2svYmxr
LW1hcC5jIGIvYmxvY2svYmxrLW1hcC5jCmluZGV4IGYxMDM3MjkuLmFkYTM5OWUgMTAwNjQ0
Ci0tLSBhL2Jsb2NrL2Jsay1tYXAuYworKysgYi9ibG9jay9ibGstbWFwLmMKQEAgLTI4Miw3
ICsyODIsOCBAQCBFWFBPUlRfU1lNQk9MKGJsa19ycV91bm1hcF91c2VyKTsKICAqCiAgKiBE
ZXNjcmlwdGlvbjoKICAqICAgIERhdGEgd2lsbCBiZSBtYXBwZWQgZGlyZWN0bHkgaWYgcG9z
c2libGUuIE90aGVyd2lzZSBhIGJvdW5jZQotICogICAgYnVmZmVyIGlzIHVzZWQuCisgKiAg
ICBidWZmZXIgaXMgdXNlZC4gQ2FuIGJlIGNhbGxlZCBtdWx0cGxlIHRpbWVzIHRvIGFwcGVu
ZCBtdWx0cGxlCisgKiAgICBidWZmZXJzLgogICovCiBpbnQgYmxrX3JxX21hcF9rZXJuKHN0
cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBzdHJ1Y3QgcmVxdWVzdCAqcnEsIHZvaWQgKmtidWYs
CiAJCSAgICB1bnNpZ25lZCBpbnQgbGVuLCBnZnBfdCBnZnBfbWFzaykKQEAgLTI5MCw2ICsy
OTEsNyBAQCBpbnQgYmxrX3JxX21hcF9rZXJuKHN0cnVjdCByZXF1ZXN0X3F1ZXVlICpxLCBz
dHJ1Y3QgcmVxdWVzdCAqcnEsIHZvaWQgKmtidWYsCiAJaW50IHJlYWRpbmcgPSBycV9kYXRh
X2RpcihycSkgPT0gUkVBRDsKIAlpbnQgZG9fY29weSA9IDA7CiAJc3RydWN0IGJpbyAqYmlv
OworCWludCByZXQ7CiAKIAlpZiAobGVuID4gKHEtPm1heF9od19zZWN0b3JzIDw8IDkpKQog
CQlyZXR1cm4gLUVJTlZBTDsKQEAgLTMxMSw3ICszMTMsMTMgQEAgaW50IGJsa19ycV9tYXBf
a2VybihzdHJ1Y3QgcmVxdWVzdF9xdWV1ZSAqcSwgc3RydWN0IHJlcXVlc3QgKnJxLCB2b2lk
ICprYnVmLAogCWlmIChkb19jb3B5KQogCQlycS0+Y21kX2ZsYWdzIHw9IFJFUV9DT1BZX1VT
RVI7CiAKLQlibGtfcnFfYmlvX3ByZXAocSwgcnEsIGJpbyk7CisJcmV0ID0gYmxrX3JxX2Fw
cGVuZF9iaW8ocSwgcnEsIGJpbyk7CisJaWYgKHVubGlrZWx5KHJldCkpIHsKKwkJLyogcmVx
dWVzdCBpcyB0b28gYmlnICovCisJCWJpb19wdXQoYmlvKTsKKwkJcmV0dXJuIHJldDsKKwl9
CisKIAlibGtfcXVldWVfYm91bmNlKHEsICZycS0+YmlvKTsKIAlycS0+YnVmZmVyID0gcnEt
PmRhdGEgPSBOVUxMOwogCXJldHVybiAwOwotLSAKMS42LjIuMQoK
--------------010107000305090505060104--
