Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C23AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 07:25:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE003238EE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 07:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbhAVHZG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 02:25:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21651 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbhAVHZC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 02:25:02 -0500
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210122072416epoutp038b623db042182a3bdf0500711cbf80b4~cfQvk1qib2481224812epoutp03T
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2021 07:24:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210122072416epoutp038b623db042182a3bdf0500711cbf80b4~cfQvk1qib2481224812epoutp03T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611300256;
        bh=7jYqdYdsSQB3N5YrinC0euhjVtrw8XhymjrSiNu1D7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQBSQ+Mk0FXKFO7O9TgeoJR0BESqeLPlf60Ht9Oe+Tq8y+PG+astki7QI2OfHZ/2D
         EBBeRN29rvU1ofdy48raVtZfmX5rcz/0Zg29VL9mi9SSjT63eAhnfBTUdd1krm4oT5
         OTdWwetJyUb+mLPP0M1WdjtwNka8W9iEcWZoiQIc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210122072415epcas1p3171d7b25b54955e4701a44c3cb0b68ba~cfQuIROTf0730607306epcas1p3e;
        Fri, 22 Jan 2021 07:24:15 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.166]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DMW3L0bM4z4x9QC; Fri, 22 Jan
        2021 07:24:14 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.A9.09577.D9D7A006; Fri, 22 Jan 2021 16:24:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2~cfQsLXazX0807608076epcas1p2M;
        Fri, 22 Jan 2021 07:24:13 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210122072413epsmtrp28558d4d89b1aed3dcce52fe338551515~cfQsJqDjF1864018640epsmtrp2v;
        Fri, 22 Jan 2021 07:24:13 +0000 (GMT)
X-AuditID: b6c32a39-bfdff70000002569-b8-600a7d9df7a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4C.54.08745.C9D7A006; Fri, 22 Jan 2021 16:24:12 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210122072412epsmtip290900d1c64c7c5ce8ba22fa362170b7c~cfQr30hBl0154101541epsmtip2q;
        Fri, 22 Jan 2021 07:24:12 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     damien.lemoal@wdc.com
Cc:     arnd@arndb.de, hch@lst.de, jejb@linux.ibm.com,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, michael.christie@oracle.com,
        mj0123.lee@samsung.com, nanich.lee@samsung.com, oneukum@suse.com,
        seunghwan.hyun@samsung.com, sookwan7.kim@samsung.com,
        woosung2.lee@samsung.com, yt0928.kim@samsung.com
Subject: Re: [PATCH 1/1] scsi: sd: use max_xfer_blocks for set rw_max if
 max_xfer_blocks is available
Date:   Fri, 22 Jan 2021 16:08:51 +0900
Message-Id: <20210122070851.16105-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <BL0PR04MB65144693C61F2192038FA5C0E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1CTdRzH+z7P9uyBWvc4rL5A2dypCQZsjo0vCsWZeuuEorrsKj14gseN
        Y7/cMwLp6vgx0RgSIndcCGIcxSm3QxFojuPiSBgCGo4EpCsqBx6oTDbhIrBr49Hiv/f383l9
        fn6/XxIXDRJhZJbezJj0tFZCBPM6foyIjqr7PDhd+psrAT2q7BOgo8cWMXSuuRdDDeMdGCpz
        F/HRwh8sGnHUEsg6ZidQk/MfzM+O81H1pVocjU4OCVDp7XMEun7Vy0dnbiehAfspHLV0LRFJ
        61TLf1cCVUVDN1B13iogVPNTEzxVedt5oGppu8lT+Vo3qI51W7FU8iNtgoahMxmTmNFnGDKz
        9OpEyb730t5IUyilsihZPIqTiPW0jkmU7E5OjdqbpfVPIRF/Smtz/KZUmmUlMa8lmAw5Zkas
        MbDmRAljzNQaZVJjNEvr2By9OjrDoNshk0q3K/xkulbT7rTxjeXyvKNLBwuAe2spCCIhFQsr
        pod5pSCYFFF2AEdmhomAQ0R5ARysUnMOH4C91z1YKSBXIzydCZzdAWB3wwD/P+hbVz8/EE1Q
        r8Ly+xOrmdZToXBg5iERgHDKisOJpjpBIFMIpYaLyyDA8KjN0H7lFzyghdROaBm38bn2XoZT
        J5pW7UHUQXhjpA3jmHXw6tduXkDjfqa4/TTO8f0kvGk/zOndcLy6F+N0CJx1tgk4HQZ9c12r
        /UDKCmBxST3gDhUANt757nGEHHp9PhBoFKciYIsjhjNvhJeX6wBX+Fk4t1DG57YihMdLRByy
        CQ5ZJvEnte7YLj/OqIKFcys4t6wLAPqqvudVAHHNmnlq1sxT83/lswA/D55njKxOzbAyo2Lt
        BbeC1VcdGW8H1fcfRPcAjAQ9AJK4ZL3wz3gyXSTMpI/kMyZDmilHy7A9QOHf9kk87LkMg/9b
        6M1pMsV2uVyOYpVxSoVc8oLwE+nvaSJKTZuZbIYxMqYncRgZFFaA5XpFhVF3s3nhysmioQln
        +CG0w3v8gzj0YHqwrKR/J62d/mx2CJuyuL8QFoNRbUSIK+nDXV2nzrzbHqbsibi4ZQN1Y+yv
        bdblbx4WhqaMZW8bnr+3NbnoXugzsYKzmJPp81SNf5ze0b6nze3I3pvSEi+wvXLpy5Gy2f2R
        +1/0fOWoH7HtKoPNKaEtrZkOItxj1a34lqjuWbluyFLbfCBG93P+NUvnTzGG0ac1Hlvepgtk
        crPy7YQrt153l2g3r5x8f8q1Uf3Ur0d8b0Use+vv/jCaFzzTaDgQucXS05FDLh5aqLQnX8s9
        3Jib3v1OxcXmectLexaQoJiXL+5zOd8cfkRIeKyGlkXiJpb+F9eJPLFeBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJXndOLVeCwatec4u/k46xW7S2f2Oy
        WLn6KJPFohvbmCx6njSxWnx9WGxxedccNovu6zvYLJYf/8cEVHuD1WL65jnMFtfun2G36Hq8
        ks3i3MlPrBbzHjtYnNoxmdli/d6fbA6CHr9/TWL0mLDoAKPH7psNbB4fn95i8ejbsorRY/2W
        qywenzfJebQf6GYK4IjisklJzcksSy3St0vgyth6fC1rQZ9xRevP2AbGJxpdjBwcEgImEu93
        23QxcnEICexglDh8rp2pi5ETKC4lcfzEW1aIGmGJw4eLQcJCAh8ZJTat0Aax2QR0JPre3mID
        sUUEJCVOvfzCBjKHWWA+s8Tf/yBzODiEBVIl9s6yA6lhEVCV2HHkNjOIzStgLdFyYy0rxCp5
        iae9y8HinAKxEhcvb2GC2BUjseP4FEaIekGJkzOfsIDYzED1zVtnM09gFJiFJDULSWoBI9Mq
        RsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgaNLS2sG4Z9UHvUOMTByMhxglOJiVRHgf
        WXIkCPGmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cA08/mX
        DYm7DdtufGtKUZ4r0fhY+Enfrqee5mzWYi0rrM2v8Ge9qeHN5tp63HFfyJl4s/sN+98eNtHP
        eKa0fGKB8t8Ngse211We4Vn+dL7+cknGc3uvT8yI/rhsz4blz1sjj9yZ1JiwZeNKpsNZ0/v/
        dap79n8yLRW/8zRrnrRW+PRtxZtD2qawe+dse7hP0PzpF7YY56s1HhZem/dvkrossPcvQ1xw
        0ofFX5/f9rASfnW7KVfvadCrnsCu/4bmgruSLi7aYfz6sz9j8U2RxRYma29Z6dSUKTOyFnTu
        muHMXsfmMknvjci8Ow/v93+pVChmN9vAoVg0MTlB606z66Jtq6atDzuhJP/H3Ke6ocZYiaU4
        I9FQi7moOBEAM6RYQRUDAAA=
X-CMS-MailID: 20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2
References: <BL0PR04MB65144693C61F2192038FA5C0E7A20@BL0PR04MB6514.namprd04.prod.outlook.com>
        <CGME20210122072413epcas1p2d7bd97c9eae97b9b77d13e2c4a2f02f2@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021/01/20 15:45, Manjong Lee wrote:
> > Add recipients for more reviews.
> 
> Please resend instead of replying to your own patch. The reply quoting corrupts
> the patch.
> 
> The patch title is very long.
> 
> > 
> >> SCSI device has max_xfer_size and opt_xfer_size,
> >> but current kernel uses only opt_xfer_size.
> >>
> >> It causes the limitation on setting IO chunk size,
> >> although it can support larger one.
> >>
> >> So, I propose this patch to use max_xfer_size in case it has valid value.
> >> It can support to use the larger chunk IO on SCSI device.
> >>
> >> For example,
> >> This patch is effective in case of some SCSI device like UFS
> >> with opt_xfer_size 512KB, queue depth 32 and max_xfer_size over 512KB.
> >>
> >> I expect both the performance improvement
> >> and the efficiency use of smaller command queue depth.
> 
> This can be measured, and this commit message should include results to show how
> effective this change is.
> 
> >>
> >> Signed-off-by: Manjong Lee <mj0123.lee@samsung.com>
> >> ---
> >> drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++++++++++++----
> >> 1 file changed, 52 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> >> index 679c2c025047..de59f01c1304 100644
> >> --- a/drivers/scsi/sd.c
> >> +++ b/drivers/scsi/sd.c
> >> @@ -3108,6 +3108,53 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
> >> sdkp->security = 1;
> >> }
> >>
> >> +static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,
> >> +				      unsigned int dev_max)
> >> +{
> >> +	struct scsi_device *sdp = sdkp->device;
> >> +	unsigned int max_xfer_bytes =
> >> +		logical_to_bytes(sdp, sdkp->max_xfer_blocks);
> >> +
> >> +	if (sdkp->max_xfer_blocks == 0)
> >> +		return false;
> >> +
> >> +	if (sdkp->max_xfer_blocks > SD_MAX_XFER_BLOCKS) {
> >> +		sd_first_printk(KERN_WARNING, sdkp,
> >> +				"Maximal transfer size %u logical blocks " \
> >> +				"> sd driver limit (%u logical blocks)\n",
> >> +				sdkp->max_xfer_blocks, SD_DEF_XFER_BLOCKS);
> >> +		return false;
> >> +	}
> >> +
> >> +	if (sdkp->max_xfer_blocks > dev_max) {
> >> +		sd_first_printk(KERN_WARNING, sdkp,
> >> +				"Maximal transfer size %u logical blocks "
> >> +				"> dev_max (%u logical blocks)\n",
> >> +				sdkp->max_xfer_blocks, dev_max);
> >> +		return false;
> >> +	}
> >> +
> >> +	if (max_xfer_bytes < PAGE_SIZE) {
> >> +		sd_first_printk(KERN_WARNING, sdkp,
> >> +				"Maximal transfer size %u bytes < " \
> >> +				"PAGE_SIZE (%u bytes)\n",
> >> +				max_xfer_bytes, (unsigned int)PAGE_SIZE);
> >> +		return false;
> >> +	}
> >> +
> >> +	if (max_xfer_bytes & (sdkp->physical_block_size - 1)) {
> >> +		sd_first_printk(KERN_WARNING, sdkp,
> >> +				"Maximal transfer size %u bytes not a " \
> >> +				"multiple of physical block size (%u bytes)\n",
> >> +				max_xfer_bytes, sdkp->physical_block_size);
> >> +		return false;
> >> +	}
> >> +
> >> +	sd_first_printk(KERN_INFO, sdkp, "Maximal transfer size %u bytes\n",
> >> +			max_xfer_bytes);
> >> +	return true;
> >> +}
> 
> Except for the order of the comparisons against SD_MAX_XFER_BLOCKS and dev_max,
> this function looks identical to sd_validate_opt_xfer_size(), modulo the use of
> max_xfer_blocks instead of opt_xfer_blocks. Can't you turn this into something like:
> 
> static bool sd_validate_max_xfer_size(struct scsi_disk *sdkp,
> const char *name,
> unsigned int xfer_blocks,
> unsigned int dev_max)
> 
> To allow checking both opt_xfer_blocks and max_xfer_blocks ?
> 
> >> +
> >> /*
> >> * Determine the device's preferred I/O size for reads and writes
> >> * unless the reported value is unreasonably small, large, not a
> >> @@ -3233,12 +3280,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
> >>
> >> /* Initial block count limit based on CDB TRANSFER LENGTH field size. */
> >> dev_max = sdp->use_16_for_rw ? SD_MAX_XFER_BLOCKS : SD_DEF_XFER_BLOCKS;
> 
> This looks weird: no indentation. Care to resend ?
> 
> >> -
> >> -	/* Some devices report a maximum block count for READ/WRITE requests. */
> >> -	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
> >> q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
> >>
> >> -	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> >> +	if (sd_validate_max_xfer_size(sdkp, dev_max)) {
> >> +		q->limits.io_opt = 0;
> >> +		rw_max = logical_to_sectors(sdp, sdkp->max_xfer_blocks);
> >> +		q->limits.max_dev_sectors = rw_max;
> >> +	} else if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
> 
> This does not look correct to me. This renders the device reported
> opt_xfer_blocks useless.
> 
> The unmodified code sets dev_max to the min of SD_MAX_XFER_BLOCKS or
> SD_DEF_XFER_BLOCKS and of the device reported max_xfer_blocks. The result of
> this is used as the device max_dev_sectors queue limit, which in turn is used to
> set the max_hw_sectors queue limit accounting for the adapter limits too.
> 
> opt_xfer_blocks, if it is valid, will be used to set the io_opt queue limit,
> which is a hint. This hint is used to optimize the "soft" max_sectors command
> limit used by the block layer to limit command size if the value of
> opt_xfer_blocks is smaller than the limit initially set with max_xfer_blocks.
> 
> So if for your device max_sectors end up being too small, it is likely because
> the device itself is reporting an opt_xfer_blocks value that is too small for
> its own good. The max_sectors limit can be manually increased with "echo xxx >
> /sys/block/sdX/queue/max_sectors_kb". A udev rule can be used to handle this
> autmatically if needed.
> 
> But to get a saner default for that device, I do not think that this patch is
> the right solution. Ideally, the device peculiarity should be handled with a
> quirk, but that is not used in scsi. So beside the udev rule trick, I am not
> sure what the right approach is here.
> 

This approach is for using sdkp->max_xfer_blocks as a rw_max.
There are no way to use it now when sdkp->opt_xfer_blocks is valid.
In my case, scsi device reports both of sdkp->max_xfer_blocks, and
sdkp->opt_xfer_blocks.

How about set larger valid value between sdkp->max_xfer_blocks,
and sdkp->opt_xfer_blocks to rw_max?

> >> q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
> >> rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
> >> } else {
> >> -- 
> >> 2.29.0
> >>
> >>
> >
