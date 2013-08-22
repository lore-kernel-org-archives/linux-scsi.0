From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 09:59:22 +0800
Message-ID: <CAEH94LgyGt=WZ=6oP1vgx826ULO_f_p89PMMzYiRq5Uf9gycQA@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
	<yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	<1377136559.12003.18.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377136559.12003.18.camel@joe-AO722>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, akinobu.mita@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 22, 2013 at 9:55 AM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2013-08-21 at 21:25 -0400, Martin K. Petersen wrote:
>> >>>>> "Joe" == Joe Perches <joe@perches.com> writes:
>>
>> Joe> I don't get this build warning in the first place and I think the
>> Joe> scsi_debug file is quite old and probably doesn't need to be
>> Joe> changed at all.
>>
>> guard isn't a boolean, it selects the checksum algorithm used.
>
> OK, maybe this then...
> ---
>  drivers/scsi/scsi_debug.c | 2 +-
>  1 file changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index cb4fefa..6fc2831 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3312,7 +3312,7 @@ static int __init scsi_debug_init(void)
>                 return -EINVAL;
>         }
>
> -       if (scsi_debug_guard > 1) {
> +       if (scsi_debug_guard < 0 || scsi_debug_guard > 1) {
I don't think that it can fix that issue.
>                 printk(KERN_ERR "scsi_debug_init: guard must be 0 or 1\n");
>                 return -EINVAL;
>         }
>
>



-- 
Regards,

Zhi Yong Wu
