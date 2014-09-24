From: "Subhash Jadavani" <subhashj@codeaurora.org>
Subject: RE: [PATCH V5 10/17] scsi: ufs: manually add well known logical units
Date: Wed, 24 Sep 2014 09:59:07 -0700
Message-ID: <001401cfd818$db2fa060$918ee120$@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org> <1411571653-22729-11-git-send-email-draviv@codeaurora.org> <20140924162444.GA20581@infradead.org> <001101cfd815$b66e0490$234a0db0$@codeaurora.org> <20140924164031.GB9474@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20140924164031.GB9474@infradead.org>
Content-Language: en-us
Sender: linux-arm-msm-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: 'Dolev Raviv' <draviv@codeaurora.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, 'Sujit Reddy Thumma' <sthumma@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

> Just after the call to scsi_remove_host sounds right to me.
> scsi_remove_host already removes all regularly scanned devices, but
because __scsi_add_device keeps and additional reference it doesn't free
those that you added manually.

Ok, we are calling scsi_remove_host() as part of ufs driver removal so we
can remove these manually added devices immediately after it. Next patch
revision should fix it.

-----Original Message-----
From: 'Christoph Hellwig' [mailto:hch@infradead.org] 
Sent: Wednesday, September 24, 2014 9:41 AM
To: Subhash Jadavani
Cc: 'Christoph Hellwig'; 'Dolev Raviv';
James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org;
linux-scsi-owner@vger.kernel.org; linux-arm-msm@vger.kernel.org;
santoshsy@gmail.com; 'Sujit Reddy Thumma'
Subject: Re: [PATCH V5 10/17] scsi: ufs: manually add well known logical
units

On Wed, Sep 24, 2014 at 09:36:37AM -0700, Subhash Jadavani wrote:
> Where do you release these references again?  It seems like they are 
> never released on the device removal path.
> 
> [Subhash] That's because these are embedded/non-removable UFS devices 
> which are always present on the board and never get removed. Do you 
> have any suggestion on how we should handle this?

Just after the call to scsi_remove_host sounds right to me.
scsi_remove_host already removes all regularly scanned devices, but because
__scsi_add_device keeps and additional reference it doesn't free those that
you added manually.
