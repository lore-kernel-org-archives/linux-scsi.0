From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v3] Add support for SCT Write Same
Date: Tue, 21 Jun 2016 22:01:56 -0500
Message-ID: <CAJVOszBXjw67-pu-vVtY_RfYqeEFMBH1nhWkjPcgV0SO0Vv4nQ@mail.gmail.com>
References: <1466435028-13886-1-git-send-email-shaun@tancheff.com>
 <1466435028-13886-2-git-send-email-shaun@tancheff.com> <yq17fdi2bb8.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq17fdi2bb8.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 21, 2016 at 9:43 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Shaun" == Shaun Tancheff <shaun@tancheff.com> writes:
>
> Shaun> SATA drives may support write same via SCT. This is useful for
> Shaun> setting the drive contents to a specific pattern (0's).
>
> As indicated a while back, my preference would be for you to add support
> for REPORT SUPPORTED OPERATION CODES. It's fine that you keep the RSOC
> response simple and only list WRITE SAME(10/16). But I want to avoid
> having different heuristics for libata's SCSI-ATA translation and for
> hardware controller ditto.
>
> Shaun> If UNMAP is not set or TRIM is not available
>
> Please do not conflate the two. We have the appropriate fallbacks at the
> block layer. It happens to be the same command descriptor but it is two
> very different implementations at the device level.
>
> If the UNMAP bit is set you need to issue a DSM TRIM. If the device does
> not support TRIM you need to return ILLEGAL REQUEST/INVALID FIELD IN
> CDB.
>
> If the UNMAP bit is not set then it's a regular WRITE SAME and should be
> issued using SCT WRITE SAME. If the device does not support SCT WRITE
> SAME you need to return ILLEGAL REQUEST/INVALID FIELD IN CDB.

Thanks for the clarification and the review.
I will work on support for REPORT SUPPORTED OPERATION CODES and
handle the WRITE SAME following the UNMAP as you described.

Thanks!

> --
> Martin K. Petersen      Oracle Linux Engineering



-- 
Shaun Tancheff
