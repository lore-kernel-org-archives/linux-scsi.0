From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: target: fixup error message in
 target_tg_pt_gp_alua_access_type_store()
Date: Thu, 27 Apr 2017 16:14:50 +0000
Message-ID: <1493309687.2625.5.camel@sandisk.com>
References: <1493302624-113570-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1493302624-113570-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <DECEEDFD4A0C9941A76CB4D971123AED@namprd04.prod.outlook.com>
Sender: target-devel-owner@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "nab@daterainc.com" <nab@daterainc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-04-27 at 16:17 +0200, Hannes Reinecke wrote:
> When setting up a target the error message:
>=20
> Unable to do set ##_name ALUA state on non valid tg_pt_gp ID: 0
>=20
> is displayed.
> Apparently concatenation doesn't work in a string; one should be using
> implicit string concatenation here.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/target/target_core_configfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index dc654fe..1f229cc 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -2559,9 +2559,9 @@ static ssize_t target_tg_pt_gp_alua_support_##_name=
##_store(		\
>  	int ret;							\
>  									\
>  	if (!t->tg_pt_gp_valid_id) {					\
> -		pr_err("Unable to do set ##_name ALUA state on non"	\
> +		pr_err("Unable to do set " #_name " ALUA state on non"	\
>  		       " valid tg_pt_gp ID: %hu\n",			\
> -		       t->tg_pt_gp_valid_id);				\
> +		       t->tg_pt_gp_valid_id);			\
>  		return -EINVAL;						\
>  	}								\

Hello Hannes,

The second change breaks the alignment of the backspaces which is unfortuna=
te.
Otherwise this patch looks fine to me.

Bart. 									\
