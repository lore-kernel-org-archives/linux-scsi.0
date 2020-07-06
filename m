Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01107C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 15:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D070220715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 15:33:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FGUnPjNW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgGFPdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:33:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38119 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729307AbgGFPdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 11:33:19 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200706153316epoutp04e168ea220badd94bdd5788bdeb4dc466~fM6mK4sEZ2902829028epoutp04y
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 15:33:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200706153316epoutp04e168ea220badd94bdd5788bdeb4dc466~fM6mK4sEZ2902829028epoutp04y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594049596;
        bh=r0QkR8ZI298rx4kFMgGwiM8CXivgHA9NZa5Y1r46aa4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=FGUnPjNWmG2LE0Zv+Zqwm9KnaNWAbMLylZ33l8aJKe7h7+eF7oJHHT+ph8EXCdQx9
         TnSNFhj8ceh+Dwk8sf0+1it1q8g6mR2mB1gTZ0RfZl0qbBixZztatbVhUwT5zCI98/
         hbETTgITo1REik2JZgARj1myghw3LX68LFmSl+3s=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200706153316epcas5p35796e33fc562e090797f558196e089b5~fM6l1GppP1065410654epcas5p3D;
        Mon,  6 Jul 2020 15:33:16 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.34.09703.B34430F5; Tue,  7 Jul 2020 00:33:15 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200706153314epcas5p1ac255eef963513d19107f44f5f9e4387~fM6kxT4xP2150721507epcas5p1M;
        Mon,  6 Jul 2020 15:33:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200706153314epsmtrp2a43cb22bae302e5a340a269151db49c7~fM6kwZZrI2125721257epsmtrp27;
        Mon,  6 Jul 2020 15:33:14 +0000 (GMT)
X-AuditID: b6c32a4a-4cbff700000025e7-ec-5f03443b2469
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        22.AE.08303.A34430F5; Tue,  7 Jul 2020 00:33:14 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200706153311epsmtip198f8d11136961e7b47c857b1af08a62e~fM6h4dPVj2319723197epsmtip1W;
        Mon,  6 Jul 2020 15:33:11 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bean Huo'" <huobean@gmail.com>, <avri.altman@wdc.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20200706123936.24799-1-huobean@gmail.com>
Subject: RE: [PATCH] scsi: ufs: change upiu_flags to be u8
Date:   Mon, 6 Jul 2020 21:03:09 +0530
Message-ID: <02e501d653aa$c38c35e0$4aa4a1a0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGt+xuRVHAbKpd3dOwZlKMA19T64wEjCYPEqUJGc3A=
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmpq61C3O8wf8FZhZ7206wW7z8eZXN
        4uDDThaLaR9+Mlt8Wr+M1WLO2QYmi0U3tjFZXN41h82i+/oONovlx/8xWSzdepPR4kNPnQOP
        x+Ur3h6X+3qZPHbOusvusXjPSyaPCYsOMHq0nNzP4vF9fQebx8ent1g8Pm+S82g/0M0UwBXF
        ZZOSmpNZllqkb5fAlfF0wiSmgieSFbf2vWRvYJwh2sXIySEhYCLx6NxXti5GLg4hgd2MEqv/
        bmKGcD4xSvxZdgTK+cwoMfnPVnaYlntb50O17GKUuPzkNjuE84ZRYvap90wgVWwCuhI7FreB
        VYkI9DBJbPxxgAUkwSzgIHHywQ6wIk4Bc4k12z6zgtjCAlYSe7vOsYHYLAIqEtP+/QKL8wpY
        Snz/dp8RwhaUODnzCdQceYntb+cwQ5ykIPHz6TKgeg6gZVYST99ClYhLHP3ZA/aChMAdDol7
        HbtYIepdJPZMOM0IYQtLvDq+Beo1KYnP7/aygcyREMiW6NllDBGukVg67xgLhG0vceDKHBaQ
        EmYBTYn1u/QhVvFJ9P5+wgTRySvR0SYEUa0q0fzuKlSntMTE7m6oAzwkrmw9yTSBUXEWkr9m
        IflrFpIHZiEsW8DIsopRMrWgODc9tdi0wCgvtVyvODG3uDQvXS85P3cTIzjNaXntYHz44IPe
        IUYmDsZDjBIczEoivL3ajPFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZV+nIkTEkhPLEnNTk0t
        SC2CyTJxcEo1ME2aGuRQOfUkd8Sq02bdO2Sk8xRlf0+MXKF5JMzDTG/PUruZlZ8Y2O1VFij9
        OeX5+fyqh+qT2fSUN4ZH/Et5pK1vmOL9aXVV7o4U8ZlP4m+f/J+3RPFv+V+ZSTqcwh+/PKnU
        dbv06iwwJa+SWfE+XTrgen/JKRduF9VC8xX8H96q30uaWCre9CPgznqtdReLtV9OiWJe11Yq
        oyeuICAi+3J3D3eCyxunzPP1plP1N+5iLYw7e+bVRf3/Fyfl38pYzPXbIHt5KHvJ94rdpz49
        /5wktftkr6736fsum9aL+04RejrV7MtiRsYJX2s+LFo0+8TxXabx9lUpR42j5nNkMjBVn736
        6tb2f3EpUlrfnyuxFGckGmoxFxUnAgBGrnko4gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWy7bCSnK6VC3O8we/9ehZ7206wW7z8eZXN
        4uDDThaLaR9+Mlt8Wr+M1WLO2QYmi0U3tjFZXN41h82i+/oONovlx/8xWSzdepPR4kNPnQOP
        x+Ur3h6X+3qZPHbOusvusXjPSyaPCYsOMHq0nNzP4vF9fQebx8ent1g8Pm+S82g/0M0UwBXF
        ZZOSmpNZllqkb5fAlfF0wiSmgieSFbf2vWRvYJwh2sXIySEhYCJxb+t8ti5GLg4hgR2MEise
        zGOESEhLXN84gR3CFpZY+e85O0TRK0aJg7/7WEESbAK6EjsWt4F1iwhMY5LYs+wIcxcjBwez
        gJPEnptJIDVCAh2MEpOO8oLYnALmEmu2fQbrFRawktjbdY4NxGYRUJGY9u8XWJxXwFLi+7f7
        jBC2oMTJmU9YIEbqSbRtBAszC8hLbH87hxniNgWJn0+XsYKUiACNfPqWBaJEXOLozx7mCYzC
        s5AMmoUwaBaSQbOQdCxgZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcqVpaOxj3
        rPqgd4iRiYPxEKMEB7OSCG+vNmO8EG9KYmVValF+fFFpTmrxIUZpDhYlcd6vsxbGCQmkJ5ak
        ZqemFqQWwWSZODilGpgCp25et0w0qS5fVtvydnR1fekxWwWez9NZi8W6pmoWesjNTQ39qXyH
        9dRHa7OtK2endxfzLHS0MYiJib+xbx2rw+GLEfeuTY4TMfF4/fMkP/+pys9LD88Osl/6rKyy
        pLf8WcjvzkfWZrGfCjMCra+6cjw9+u7y1kNPDa2KLPYz9MelfqtP9jfq6bX+e1A3d2OStrB1
        6TPVFcYRH5b8SPyynWef9mFTLslVefYrArW/HOM8PlXuW6BiQO6eL4sNfRY0+YcKCbDde8T0
        z2z1wUqLVfmyVTEOmo7/Lu0xZlS7sK+BO5Z/CmfAmsWKSxb3lKhuFn3DcP71ywQuaTGj2NTe
        TUqhXyds3vbBo3xBshJLcUaioRZzUXEiAIDIRZ1DAwAA
X-CMS-MailID: 20200706153314epcas5p1ac255eef963513d19107f44f5f9e4387
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200706123959epcas5p27fe7e69ea9e26089cffb2784a45e02a6
References: <CGME20200706123959epcas5p27fe7e69ea9e26089cffb2784a45e02a6@epcas5p2.samsung.com>
        <20200706123936.24799-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bean

> -----Original Message-----
> From: Bean Huo <huobean@gmail.com>
> Sent: 06 July 2020 18:10
> To: alim.akhtar@samsung.com; avri.altman@wdc.com;
> asutoshd@codeaurora.org; jejb@linux.ibm.com; martin.petersen@oracle.com;
> stanley.chu@mediatek.com; beanhuo@micron.com; bvanassche@acm.org;
> tomas.winkler@intel.com; cang@codeaurora.org
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: ufs: change upiu_flags to be u8
> 
> From: Bean Huo <beanhuo@micron.com>
> 
> According to the UFS Spec, the Flags in the UPIU is one-byte length, not
> 4 bytes. change it to be u8.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Booted and tested on exynos7 board, tested basic read/write, so
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>

Thanks,

>  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 96d830bb900f..d7fd5891e81f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2240,7 +2240,7 @@ static void ufshcd_disable_intr(struct ufs_hba *hba,
> u32 intrs)
>   * @cmd_dir: requests data direction
>   */
>  static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
> -			u32 *upiu_flags, enum dma_data_direction cmd_dir)
> +			u8 *upiu_flags, enum dma_data_direction cmd_dir)
>  {
>  	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
>  	u32 data_direction;
> @@ -2286,7 +2286,7 @@ static void ufshcd_prepare_req_desc_hdr(struct
> ufshcd_lrb *lrbp,
>   * @upiu_flags: flags
>   */
>  static
> -void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u32
> upiu_flags)
> +void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp, u8
> +upiu_flags)
>  {
>  	struct scsi_cmnd *cmd = lrbp->cmd;
>  	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr; @@ -2319,7
> +2319,7 @@ void ufshcd_prepare_utp_scsi_cmd_upiu(struct ufshcd_lrb *lrbp,
> u32 upiu_flags)
>   * @upiu_flags: flags
>   */
>  static void ufshcd_prepare_utp_query_req_upiu(struct ufs_hba *hba,
> -				struct ufshcd_lrb *lrbp, u32 upiu_flags)
> +				struct ufshcd_lrb *lrbp, u8 upiu_flags)
>  {
>  	struct utp_upiu_req *ucd_req_ptr = lrbp->ucd_req_ptr;
>  	struct ufs_query *query = &hba->dev_cmd.query; @@ -2376,7 +2376,7
> @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
> static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
>  				      struct ufshcd_lrb *lrbp)
>  {
> -	u32 upiu_flags;
> +	u8 upiu_flags;
>  	int ret = 0;
> 
>  	if ((hba->ufs_version == UFSHCI_VERSION_10) || @@ -2404,7 +2404,7
> @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
>   */
>  static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb
*lrbp)  {
> -	u32 upiu_flags;
> +	u8 upiu_flags;
>  	int ret = 0;
> 
>  	if ((hba->ufs_version == UFSHCI_VERSION_10) || @@ -6124,7 +6124,7
> @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>  	int tag;
>  	struct completion wait;
>  	unsigned long flags;
> -	u32 upiu_flags;
> +	u8 upiu_flags;
> 
>  	down_read(&hba->clk_scaling_lock);
> 
> --
> 2.17.1


