From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH] SCSI: DTC: Removed 0 initialization for statics
Date: Tue, 25 Aug 2015 11:54:26 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1508251153090.5160@nippy.intranet>
References: <1435517285-13411-1-git-send-email-rudhresh.jk@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1435517285-13411-1-git-send-email-rudhresh.jk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rudhresh Kumar J <rudhreshj@cdac.in>
Cc: schmitzmic@gmail.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Mon, 29 Jun 2015, Rudhresh wrote:

> Removed unneccessary initialization of zero to a static variable
> 
> Signed-off-by: Rudhresh Kumar J <rudhreshj@cdac.in>
> ---
>  drivers/scsi/dtc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
> index 4c74c7b..99164d6 100644
> --- a/drivers/scsi/dtc.c
> +++ b/drivers/scsi/dtc.c
> @@ -150,7 +150,7 @@ static const struct signature {
>  
>  static int __init dtc_setup(char *str)
>  {
> -	static int commandline_current = 0;
> +	static int commandline_current;
>  	int i;
>  	int ints[10];
>  
> @@ -188,7 +188,7 @@ __setup("dtc=", dtc_setup);
>  
>  static int __init dtc_detect(struct scsi_host_template * tpnt)
>  {
> -	static int current_override = 0, current_base = 0;
> +	static int current_override, current_base;
>  	struct Scsi_Host *instance;
>  	unsigned int addr;
>  	void __iomem *base;
> 

This issue affects all four copies of this code in the NCR5380 drivers:

drivers/scsi/t128.c:    static int commandline_current = 0;
drivers/scsi/t128.c:    static int current_override = 0, current_base = 0;
drivers/scsi/dtc.c:     static int commandline_current = 0;
drivers/scsi/dtc.c:     static int current_override = 0, current_base = 0;
drivers/scsi/g_NCR5380.c:       static int commandline_current = 0;
drivers/scsi/g_NCR5380.c:       static int current_override = 0;
drivers/scsi/pas16.c:    static int commandline_current = 0;
drivers/scsi/pas16.c:    static int current_override = 0;
drivers/scsi/pas16.c:    static unsigned short current_base = 0;

And there are more instances of redundant initialization in pas16.c, 
NCR5380.c and sun3_scsi.c.

All of these drivers have the same maintainers, so I'd prefer a single 
patch to fix this.

You must address your patches to all of the interested parties (see 
scripts/get_maintainer.pl).

-- 
