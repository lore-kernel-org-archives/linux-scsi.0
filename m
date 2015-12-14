From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/7] iscsi-target: Use a variable initialisation in
 iscsi_set_default_param() directly
Date: Mon, 14 Dec 2015 09:41:14 +0100
Message-ID: <20151214084114.GB31151@c203.arch.suse.de>
References: <566ABCD9.1060404@users.sourceforge.net>
 <566C2F7B.6030704@users.sourceforge.net>
 <566C308A.6000109@users.sourceforge.net>
 <20151212194939.GQ5284@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151212194939.GQ5284@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 12, 2015 at 10:49:40PM +0300, Dan Carpenter wrote:
> On Sat, Dec 12, 2015 at 03:34:50PM +0100, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring@users.sourceforge.net>
> > Date: Sat, 12 Dec 2015 11:36:02 +0100
> >=20
> > Omit the unnecessary setting to a null pointer for the variable "pa=
ram"
> > at the beginning of the function "iscsi_set_default_param"
> > because it can be directly initialized with the return value
> > from the function "kzalloc".
> >=20
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> > ---
> >  drivers/target/iscsi/iscsi_target_parameters.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drive=
rs/target/iscsi/iscsi_target_parameters.c
> > index 3a1f9a7..0a8bd3f 100644
> > --- a/drivers/target/iscsi/iscsi_target_parameters.c
> > +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> > @@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_pa=
ram(struct iscsi_param_list *para
> >  		char *name, char *value, u8 phase, u8 scope, u8 sender,
> >  		u16 type_range, u8 use)
> >  {
> > -	struct iscsi_param *param =3D NULL;
> > +	struct iscsi_param *param =3D kzalloc(sizeof(*param), GFP_KERNEL)=
;
> > =20
> > -	param =3D kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
> >  	if (!param) {
> >  		pr_err("Unable to allocate memory for parameter.\n");
> >  		goto out;
>=20
> It's better to just get rid of the initialization but leave the
> kzalloc() as-is for two reasons.
>=20
> 1)  Initializer code normally contains more bugs per line than other
>     code.  I am thinking about dereferencing pointers before checking
>     for NULL or not checking the allocation for failure.
>=20
> 2)  It puts a blank line between the allocation and the check for
>     failure.  It's like a new paragraph.  The allocation and the chec=
k
>     should be next to each other.

I agree with Dan here. Please don't do it.

@@ -127,9 +127,8 @@ static struct iscsi_param *iscsi_set_default_param(=
struct iscsi_param_list *para
 		char *name, char *value, u8 phase, u8 scope, u8 sender,
 		u16 type_range, u8 use)
 {
-	struct iscsi_param *param =3D NULL;
+	struct iscsi_param *param;
=20
	param =3D kzalloc(sizeof(struct iscsi_param), GFP_KERNEL);
 	if (!param) {
 		pr_err("Unable to allocate memory for parameter.\n");


This way it would be _far_ more readable. IMHO one should have a 1 acti=
on per
line of code style and only assign values in at declaration time if rea=
lly=20
necessary.

But what is the benefit from this? Is it fixing a (hypothetical) bug? I=
 somehow
fail to see it.

Thanks,
	Johannes

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
