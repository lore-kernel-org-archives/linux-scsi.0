From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: megaraid 2.00rc5 -> kernel 2.5.41 diff
Date: Tue, 8 Oct 2002 10:48:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021008174837.GA1082@beaverton.ibm.com>
References: <Pine.LNX.4.44.0210081155390.32358-100000@humbolt.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0210081155390.32358-100000@humbolt.us.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: linux-scsi@vger.kernel.org

Matt Domsch [Matt_Domsch@Dell.com] wrote:
> @@ -2032,7 +2034,8 @@
>  				if( cmd->use_sg ) {
>  					sgl = (struct scatterlist *)
>  						cmd->request_buffer;
> -					c = *(u8 *)sgl[0].address;
> +					/* MLD - is this right??  */
> +					c = *(u8 *)page_address(sgl[0].page);
>  				}
>  				else {
>  					c = *(u8 *)cmd->request_buffer;

Matt,
	I do not have the megaraid 2.00rc5 source so I cannot see the
	context around this change, but the above looks incorrect as you
	do take into account that the page may have an offset.
-andmike
--
Michael Anderson
andmike@us.ibm.com

