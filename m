From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] bfa: Implement LUN Masking feature using the SCSI Slave
 Callouts.
Date: Wed, 27 Jun 2012 12:05:55 +0300
Message-ID: <20120627090555.GN31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

This bug is still present in linux-next.

regards,
dan carpenter

On Wed, Jan 11, 2012 at 12:32:34PM +0300, Dan Carpenter wrote:
> Hello Krishna Gudipati,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 5b7db7af522d: "[SCSI] bfa: Implement LUN Masking feature 
> using the SCSI Slave Callouts." from Dec 20, 2011, leads to the 
> following Smatch complaint:
> 
> drivers/scsi/bfa/bfad_im.c +962 bfad_im_slave_alloc()
> 	 warn: variable dereferenced before check 'rport' (see line 959)
> 
> drivers/scsi/bfa/bfad_im.c
>    957          struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
>    958		struct bfad_itnim_data_s *itnim_data =
>    959					(struct bfad_itnim_data_s *) rport->dd_data;
>                                                                      ^^^^^^^
> New dereference.
> 
>    960		struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
>    961	
>    962		if (!rport || fc_remote_port_chkready(rport))
>                      ^^^^^
> Old check.
> 
>    963			return -ENXIO;
>    964	
> 
> regards,
> dan carpenter
> 
