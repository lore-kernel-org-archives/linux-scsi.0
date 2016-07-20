From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v3 5/7] iscsi-target: replace
 iscsi_initiatorname_tolower() with strtolower()
Date: Wed, 20 Jul 2016 14:17:11 -0700
Message-ID: <1469049431.13881.16.camel@haakon3.risingtidesystems.com>
References: <1468017794-4818-1-git-send-email-mmayer@broadcom.com>
	 <1468017794-4818-6-git-send-email-mmayer@broadcom.com>
	 <1469049365.13881.15.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469049365.13881.15.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Markus Mayer <mmayer@broadcom.com>
Cc: Roland Dreier <roland@purestorage.com>, Varun Prakash <varun@chelsio.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-07-20 at 14:16 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2016-07-08 at 15:43 -0700, Markus Mayer wrote:
> > After introducing generic strtolower(), iscsi_initiatorname_tolower() is
> > no longer needed.
> > 
> > Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> > ---
> >  drivers/target/iscsi/iscsi_target_nego.c | 17 +----------------
> >  1 file changed, 1 insertion(+), 16 deletions(-)
> > 
> > diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> > index 89d34bd..fa20638 100644
> > --- a/drivers/target/iscsi/iscsi_target_nego.c
> > +++ b/drivers/target/iscsi/iscsi_target_nego.c
> > @@ -987,21 +987,6 @@ static int iscsi_target_do_login(struct iscsi_conn *conn, struct iscsi_login *lo
> >  	return 0;
> >  }
> >  
> > -static void iscsi_initiatorname_tolower(
> > -	char *param_buf)
> > -{
> > -	char *c;
> > -	u32 iqn_size = strlen(param_buf), i;
> > -
> > -	for (i = 0; i < iqn_size; i++) {
> > -		c = &param_buf[i];
> > -		if (!isupper(*c))
> > -			continue;
> > -
> > -		*c = tolower(*c);
> > -	}
> > -}
> > -
> >  /*
> >   * Processes the first Login Request..
> >   */
> > @@ -1075,7 +1060,7 @@ int iscsi_target_locate_portal(
> >  	 * RFC-3720 3.2.6.1. section c) that says that iSCSI IQNs
> >  	 * are NOT case sensitive.
> >  	 */
> > -	iscsi_initiatorname_tolower(i_buf);
> > +	strtolower(i_buf);
> >  
> >  	if (!s_buf) {
> >  		if (!login->leading_connection)
> 
> Applied to target-pending/for-next.
> 
> Thanks Markus.
> 

Er, my bad.  It's not a stand-alone patch..

In that case for the iscsi-target part:

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>
