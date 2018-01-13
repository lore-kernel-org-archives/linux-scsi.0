From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH -next] tcmu: fix error return code in
 tcmu_configure_device()
Date: Fri, 12 Jan 2018 21:19:05 -0800
Message-ID: <1515820745.24576.89.camel@haakon3.daterainc.com>
References: <1515669145-125352-1-git-send-email-weiyongjun1@huawei.com>
         <5A579A9C.3090004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34610 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750728AbeAMFTJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Jan 2018 00:19:09 -0500
In-Reply-To: <5A579A9C.3090004@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Thu, 2018-01-11 at 11:10 -0600, Mike Christie wrote:
> On 01/11/2018 05:12 AM, Wei Yongjun wrote:
> > Fix to return error code -ENOMEM from the kzalloc() error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Fixes: fabe6a59cc5a ("tcmu: allow max block and global max blocks to be settable")
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  drivers/target/target_core_user.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> > index bac08bc..2edd242 100644
> > --- a/drivers/target/target_core_user.c
> > +++ b/drivers/target/target_core_user.c
> > @@ -1705,8 +1705,10 @@ static int tcmu_configure_device(struct se_device *dev)
> >  
> >  	udev->data_bitmap = kzalloc(BITS_TO_LONGS(udev->max_blocks) *
> >  				    sizeof(unsigned long), GFP_KERNEL);
> > -	if (!udev->data_bitmap)
> > +	if (!udev->data_bitmap) {
> > +		ret = -ENOMEM;
> >  		goto err_bitmap_alloc;
> > +	}
> >  
> >  	udev->mb_addr = vzalloc(CMDR_SIZE);
> >  	if (!udev->mb_addr) {
> > 
> 
> Thanks.
> 
> Acked-by: Mike Christie <mchristi@redhat.com>

Applied.  Thanks Wei + MNC.
