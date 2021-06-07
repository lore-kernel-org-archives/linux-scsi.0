Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326E2C4743F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D84661107
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 09:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhFGJm3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 05:42:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52803 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhFGJm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 05:42:28 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210607094035epoutp020e5808052868cf809a7006e85263b84f~GQ2lMrdHc0455204552epoutp02y
        for <linux-scsi@vger.kernel.org>; Mon,  7 Jun 2021 09:40:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210607094035epoutp020e5808052868cf809a7006e85263b84f~GQ2lMrdHc0455204552epoutp02y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623058835;
        bh=5QbUxacVjicXIUqFWDDC3OxkkBRcg5dBU0ahGmISkxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VRt9crE4KIfg5K8Tzy3M6lokB52HhlOlBoIbcNU1hH+rCDP+6A4U1fJkDTne26ofx
         rpyE7tPdwgu8/XnILRd5z8uMT4iEKk/LiWXgmbWeIM0Pc4pCwKHECHFP92a8umj/tp
         9VjfImk3K9//EAlXF8C2r4kDyBHTcmhxbQi8GRqg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210607094033epcas1p2769ecd2b169e74dbb9a9cf5cac9566c3~GQ2j0mu5m2009220092epcas1p2b;
        Mon,  7 Jun 2021 09:40:33 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.165]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Fz7dr3Hlpz4x9Py; Mon,  7 Jun
        2021 09:40:32 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.67.09736.099EDB06; Mon,  7 Jun 2021 18:40:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210607094031epcas1p1f4a9ee01eaa4652ba0e8eb6a4964c952~GQ2hwV9LS2551625516epcas1p1r;
        Mon,  7 Jun 2021 09:40:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210607094031epsmtrp2ba1e4997e34ef5f4867334171326fc37~GQ2hvEmsB1681416814epsmtrp2g;
        Mon,  7 Jun 2021 09:40:31 +0000 (GMT)
X-AuditID: b6c32a39-8d9ff70000002608-43-60bde9909318
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AB.43.08637.F89EDB06; Mon,  7 Jun 2021 18:40:31 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210607094031epsmtip16d3917880caace85b863b6dcd8582d28~GQ2hZaeAF1612816128epsmtip1Y;
        Mon,  7 Jun 2021 09:40:31 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     bvanassche@acm.org
Cc:     Johannes.Thumshirn@wdc.com, alex_y_xu@yahoo.ca,
        alim.akhtar@samsung.com, asml.silence@gmail.com,
        avri.altman@wdc.com, axboe@kernel.dk, bgoncalv@redhat.com,
        cang@codeaurora.org, damien.lemoal@wdc.com,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, nanich.lee@samsung.com, osandov@fb.com,
        patchwork-bot@kernel.org, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, tj@kernel.org, tom.leiming@gmail.com,
        woosung2.lee@samsung.com, yi.zhang@redhat.com,
        yt0928.kim@samsung.com
Subject: Re: [PATCH v12 3/3] ufs: set max_bio_bytes with queue max sectors
Date:   Mon,  7 Jun 2021 18:21:56 +0900
Message-Id: <20210607092156.16774-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <004bef40-1667-3b60-adaf-bea2b15f2514@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0xTVxTHd99rXwsR7QpjN4RJV7dsMPlRELygMBKNPsFkkM1lY1tKhbfC
        6K+0xSkzSqiUDRBKjBg7fjhgyFAHQegKA9QSbZBSR8qvIcoYMAYbv4VRcGQtDzP+u+fcz/d+
        zzk3h41zDSwvdqpMTSllIgmfcGUYOnz9/XVTbYlBa6Uc9OPwTRb6rcxAoJJaA0BT9j4C3XhS
        SKCWnnKAiuftOFqsq2ai7JwVDGkq6wjUpavA0HidHkcVgwYM5Y9nMdG/uU8xtDyqQm1D7yBb
        SwmB8gaMBLpu3sCQ6ZIGQ1dul+Cof8TCQh1P+xhotKoIR9bORSYqG4tGa9fvAzS3OsBCD42X
        cDRgLSZQXZudiOaRtt5Y0lZwESOLNLMssln/hEXervEjbd3pZEPtNwSpq7gLyDulN1nkwsQQ
        g5xr7yPIgsZaQC417CZz7uZhpMlUjcftSpAcTKFEyZSSR8mS5MmpMnEkP/Z94SFhaFiQwF8Q
        jvbzeTKRlIrkHz4e538kVeKYF593SiRJd6TiRCoVPzDqoFKerqZ4KXKVOpJPKZIlCkGQIkAl
        kqrSZeKAJLk0QhAUFBzqIBMlKYYOK6Hocj89PXIPZIJnu3IBmw05+2B/f0wucGFzOUYAH5ik
        ucDVcV4EsOhxHYMOVgC0P75FOCmnYK31GpO+aAPwvrZyK1gC0KRZwJwUwdkLC2aGNhUeHE9o
        e7YCnBDOmWHCekshcHq7c2Jg5eSnTobBeRPaF2ybvBvnALywoGfQbj7w+Ug+7sRdHPm5R540
        8jLsvDq+ieAORNP0Le58HnL+cIHtpVaM1h6GP2k1W1W7w2lzI4s+e8Gl2TaCFuQBqNGWAzrQ
        AVg1Wb2lDoGLS0ubheIcX1jXEkinX4fN66WAdt4JZ5fzmfQc3eDXWi6NvAEtF0bwF16Tt5q3
        XiThX4XNBD2sAgBnxkZxHeDptzWk39aQ/n/nawCvBZ6UQiUVUyqBInT7DzeAzQXyCzeCKzPz
        ASaAsYEJQDbO93CL8W5N5Loli85kUEq5UJkuoVQmEOqYdhHu9UqS3LGBMrVQEBocEhKC9oXt
        DwsN4b/qJj70VSKXIxapqTSKUlDKFzqM7eKVieWci31QFJHicj5cG7ZT2Dk8re3d4Xvgy5qu
        73S/W3nLtSuv5XrzWVm6mB7QdARGV73tP22eP7ZafJbnHd1YHMJzvVHs41Hf8PmHINuU/XNR
        4Mfl4uYT8Z/9UPOwv37GKu1mLGc0nGSVLcTbuPnhf34SxTypWW8yl6whon49Stnzvdh8Lj5b
        dOeopU9/PK0+w2d3QoN2cNy7bEq4IuvJUX7xd5k6fTrh9NmWxGDBoziVeU+r6Iw5x3hvw55m
        ic/K8zlvX5hQJF/WtQ++d+qXw7WNV/f+80FmbLxh+GLvxAnf/EK2VX050Tj6UVXXu3vGnr+l
        6XbpWj06FvfShqUH7Ij4tY3PUKWIBH64UiX6Dwympl7JBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWy7bCSnG7/y70JBjvXSVisu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBnbDp9jKzgtXPHq/kHGBsYv/F2M
        nBwSAiYSv/YsYO1i5OIQEtjNKNH4s48JIiElcfzEW6AEB5AtLHH4cDFIWEjgI6NEc382iM0m
        oCPR9/YWG4gtIiAmcfnLN0aQOcwCU9kkZj0/wwTSKyzgJbH4eQxIDYuAqsTPj5fB6nkFrCVa
        Ps5igVglL/Hnfg8zSDknUPz9eTEQU0jASmLf9wiIakGJkzOfgFUzA1U3b53NPIFRYBaS1Cwk
        qQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYIThJbmDsbtqz7oHWJk4mA8xCjB
        wawkwuslsydBiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+FrpPxQgLpiSWp2ampBalFMFkmDk6p
        BqatK+wnrfG+tW6P2/7nFiKR4R55vM9vbXbfaHFHravD8PGsv3tNYzezOLhPm6H8JdXNlmcb
        S4b+xavK/42mnalbo2axccc+IR6n50+0eo8cTuSdsMTk/QwhsdtXfql+Tk8w+PbzTVdOztYd
        Ju6PZ/ivel8qejSK/+fHpTJP36WyHq4Pun4tYmUG28284HsHXV2Lp7SLWf/NYg1m2vjMk8fj
        i/0avluM13wOWG+S43AxabA98OG8368Gb2Gnx1IJ/nY/ZoQ8zFg8+6HxriAZ2f8nXli6nbC+
        L1H24/RxmXP6SRNjGVp7ZZiPRzpfsmO3t/229EV+Q8Ph2qWJv0v1l3+YELLowtQDvq5KWdEf
        1nUpsRRnJBpqMRcVJwIAtf7lrn8DAAA=
X-CMS-MailID: 20210607094031epcas1p1f4a9ee01eaa4652ba0e8eb6a4964c952
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210607094031epcas1p1f4a9ee01eaa4652ba0e8eb6a4964c952
References: <004bef40-1667-3b60-adaf-bea2b15f2514@acm.org>
        <CGME20210607094031epcas1p1f4a9ee01eaa4652ba0e8eb6a4964c952@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 6/3/21 10:03 PM, Changheun Lee wrote:
> > Set max_bio_bytes same with queue max sectors. It will lead to fast bio
> > submit when bio size is over than queue max sectors. And it might be helpful
> > to align submit bio size in some case.
> > 
> > Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 3eb54937f1d8..37365a726517 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -4858,6 +4858,7 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
> >  {
> >  	struct ufs_hba *hba = shost_priv(sdev->host);
> >  	struct request_queue *q = sdev->request_queue;
> > +	unsigned int max_bio_bytes;
> >  
> >  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
> >  	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
> > @@ -4868,6 +4869,10 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
> >  
> >  	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
> >  
> > +	if (!check_shl_overflow(queue_max_sectors(q),
> > +				SECTOR_SHIFT, &max_bio_bytes))
> > +		blk_queue_max_bio_bytes(q, max_bio_bytes);
> > +
> >  	return 0;
> >  }
> 
> Just like previous versions of this patch series, this approach will
> trigger data corruption if dm-crypt is stacked on top of the UFS driver
> since ufs_max_sectors << SECTOR_SHIFT = 1024 * 512 is less than the size
> of the dm-crypt buffer (BIO_MAX_VECS << PAGE_SHIFT = 256 * 4096).

max_bio_bytes can't be smaller than "BIO_MAX_VECS * PAGE_SIZE". Large value
will be selected between input parameter and  "BIO_MAX_VECS * PAGE_SIZE" in
blk_queue_max_bio_bytes(). I think bio max size should be larger than
"BIO_MAX_VECS * PAGE_SIZE" for kernel stability.

void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int bytes)
{
	struct queue_limits *limits = &q->limits;
	unsigned int max_bio_bytes = round_up(bytes, PAGE_SIZE);

	limits->max_bio_bytes = max_t(unsigned int, max_bio_bytes,
				      BIO_MAX_VECS * PAGE_SIZE);
}
EXPORT_SYMBOL(blk_queue_max_bio_bytes);

> 
> I am not recommending to increase max_sectors for the UFS driver. We
> need a solution that is independent of the dm-crypt internals.
> 
> Bart.

No need to increase max_sectors in driver to set max_bio_bytes. There are
no dependency with dm-crypt I think.

Thank you,
Changheun Lee
