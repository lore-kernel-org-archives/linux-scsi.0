From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v6 1/2] tcmu: Add dynamic growing data area feature
 support
Date: Sun, 30 Apr 2017 00:48:48 -0500
Message-ID: <59057AC0.2090804@redhat.com>
References: <1493187952-13125-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1493187952-13125-2-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1493187952-13125-2-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: agrover@redhat.com, iliastsi@arrikto.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

On 04/26/2017 01:25 AM, lixiubo@cmss.chinamobile.com wrote:
>  	for_each_sg(data_sg, sg, data_nents, i) {
> @@ -275,22 +371,26 @@ static void alloc_and_scatter_data_area(struct tcmu_dev *udev,
>  		from = kmap_atomic(sg_page(sg)) + sg->offset;
>  		while (sg_remaining > 0) {
>  			if (block_remaining == 0) {
> -				block = find_first_zero_bit(udev->data_bitmap,
> -						DATA_BLOCK_BITS);
>  				block_remaining = DATA_BLOCK_SIZE;
> -				set_bit(block, udev->data_bitmap);
> +				dbi = tcmu_get_empty_block(udev, &to);
> +				if (dbi < 0)


I know it you fixed the missing kunmap_atomic here and missing unlock in
tcmu_queue_cmd_ring in the next patch, but I think normally people
prefer that one patch does not add a bug, then the next patch fixes it.
