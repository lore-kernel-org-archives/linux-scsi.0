Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490A305968;
	Mon, 23 Feb 2026 16:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771862618; cv=none; b=chs2RVEajMpofYIYuCjKQtfy3NJ31kuxusSrQheCH4XF7Hjav1ZumQK/lP3nDOB+KQgg0B4JaWLKsos2dnbYn6+5zrOa9ZnDEKYP/4RxXEu0lh80BMTgwgA1OFMdGj0N1lsUGF7/VMu7i2Tq5fl4d2qr3anr7DwzCYBuRDK/tlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771862618; c=relaxed/simple;
	bh=fUZywR85ZLqlkooWVb3PpWrCKi9HfZ8n2/LCbW7UrbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IK1uyM9stSLbPukzs9koC/qKR/sLsODfdNZ0ofbxU+Xg6ExRyth9ZZTaN1dUxTvI3sAZyf5z8qpKKrEiqlhDq4rUSF8Xpvs/tk/zyx8nNNzqKDdUjd0QFZa4yCG37xkX7s5fCoVEVNagsXjLxiKrUbuZ410T4oGzdmJZcG2Gqq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjfYNNFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjfYNNFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC20C116C6;
	Mon, 23 Feb 2026 16:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771862618;
	bh=fUZywR85ZLqlkooWVb3PpWrCKi9HfZ8n2/LCbW7UrbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OjfYNNFnZFDM/GCq+/T5V8mDIgprjxPhN3fBjd++EAPtWOxJQ+5DZj+7jYTi2sl1Y
	 STpaXbrZ9a0rP35Pmkobmdvf96msD5sw2Nsuwp9i8RXlSHNmCHcQERdtMQM24wwEKR
	 PjyqyLMrFXXkLK0cdLO+EviWmqsWuCnNei5JFHlI=
Date: Mon, 23 Feb 2026 17:03:20 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>
Subject: Re: [PATCH] scsi: ses: Handle positive SCSI error from
 ses_recv_diag()
Message-ID: <2026022355-dress-revoke-89ea@gregkh>
References: <2026022301-bony-overstock-a07f@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026022301-bony-overstock-a07f@gregkh>

On Mon, Feb 23, 2026 at 04:44:59PM +0100, Greg Kroah-Hartman wrote:
> ses_recv_diag() can return a positive value, which also means that an
> error happened, so do not only test for negative values.
> 
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: stable <stable@kernel.org>
> Assisted-by: gkh_clanker_2000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/scsi/ses.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 35101e9b7ba7..128042c734cc 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -215,7 +215,7 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
>  	unsigned char *type_ptr = ses_dev->page1_types;
>  	unsigned char *desc_ptr = ses_dev->page2 + 8;
>  
> -	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
> +	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
>  		return NULL;
>  
>  	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {
> -- 
> 2.53.0
> 

Along these lines, any specific reason why the following code in
ses_enclosure_data_process() doesn't also check the return value of
ses_recv_diag():

	/* re-read page 10 */
	if (ses_dev->page10)
		ses_recv_diag(sdev, 10, ses_dev->page10, ses_dev->page10_len);
	/* Page 7 for the descriptors is optional */
	result = ses_recv_diag(sdev, 7, hdr_buf, INIT_ALLOC_SIZE);
	if (result)
		goto simple_populate;

Is that because re-reading always succeeds, or because it can fail and
we just want to ignore it?  It feels odd that the "optional" read
command for page 7 is checked by not page 10.  But hey, scsi is odd :)

thank,s

greg k-h
