From: James Bottomley <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: ses: Fix out-of-bounds memory access in
 ses_enclosure_data_process()
Date: Mon, 20 May 2019 07:52:18 -0700
Message-ID: <1558363938.3742.1.camel@linux.ibm.com>
References: <20190501180535.26718-1-longman@redhat.com>
         <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1fd39969-4413-2f11-86b2-729787680efa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Waiman Long <longman@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2019-05-20 at 10:41 -0400, Waiman Long wrote:
[...]
> > --- a/drivers/scsi/ses.c
> > +++ b/drivers/scsi/ses.c
> > @@ -605,9 +605,14 @@ static void ses_enclosure_data_process(struct
> > enclosure_device *edev,
> >  			     /* these elements are optional */
> >  			     type_ptr[0] ==
> > ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
> >  			     type_ptr[0] ==
> > ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
> > -			     type_ptr[0] ==
> > ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
> > +			     type_ptr[0] ==
> > ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
> >  				addl_desc_ptr += addl_desc_ptr[1]
> > + 2;
> >  
> > +				/* Ensure no out-of-bounds memory
> > access */
> > +				if (addl_desc_ptr >= ses_dev-
> > >page10 +
> > +						     ses_dev-
> > >page10_len)
> > +					addl_desc_ptr = NULL;
> > +			}
> >  		}
> >  	}
> >  	kfree(buf);
> 
> Ping! Any comment on this patch.

The update looks fine to me:

Reviewed-by: James E.J. Bottomley <jejb@linux.ibm.com>

It might also be interesting to find out how the proliant is
structuring this descriptor array to precipitate the out of bounds: Is
it just an off by one or something more serious?

James
