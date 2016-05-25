From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard capability
 to the tcm_qla2xxx module
Date: Wed, 25 May 2016 16:12:41 -0400 (EDT)
Message-ID: <448968450.37971910.1464207161972.JavaMail.zimbra@redhat.com>
References: <2025450295.25603731.1459262558755.JavaMail.zimbra@redhat.com> <363538615.26701710.1459617008813.JavaMail.zimbra@redhat.com> <1459640375.13184.14.camel@haakon3.risingtidesystems.com> <1261843246.27018882.1459691827923.JavaMail.zimbra@redhat.com> <1459803251.10124.7.camel@haakon3.risingtidesystems.com> <40304386.27344954.1459810203532.JavaMail.zimbra@redhat.com> <1911585367.34699247.1462805764493.JavaMail.zimbra@redhat.com> <2101E9AC-9DF3-4EB0-B89B-E4272C4C6071@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:36440 "EHLO
	mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbcEYUMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2016 16:12:47 -0400
In-Reply-To: <2101E9AC-9DF3-4EB0-B89B-E4272C4C6071@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>



----- Original Message -----
> From: "Himanshu Madhani" <himanshu.madhani@qlogic.com>
> To: "Laurence Oberman" <loberman@redhat.com>, "Nicholas A. Bellinger"=
 <nab@linux-iscsi.org>
> Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, "linux-scsi" <lin=
ux-scsi@vger.kernel.org>, "target-devel"
> <target-devel@vger.kernel.org>, "Quinn Tran" <quinn.tran@qlogic.com>
> Sent: Monday, May 9, 2016 1:08:36 PM
> Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard cap=
ability to the tcm_qla2xxx module
>=20
> On 5/9/16, 7:56 AM, "Laurence Oberman" <loberman@redhat.com> wrote:
>=20
>=20
>=20
> >
> >
> >----- Original Message -----
> >> From: "Laurence Oberman" <loberman@redhat.com>
> >> To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> >> Cc: "Himanshu Madhani" <himanshu.madhani@qlogic.com>, "Bart Van As=
sche"
> >> <bart.vanassche@sandisk.com>, "linux-scsi"
> >> <linux-scsi@vger.kernel.org>, "target-devel"
> >> <target-devel@vger.kernel.org>, "Quinn Tran" <quinn.tran@qlogic.co=
m>
> >> Sent: Monday, April 4, 2016 6:50:03 PM
> >> Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard
> >> capability to the tcm_qla2xxx module
> >>=20
> >> Hello Nicholas
> >>=20
> >> Its fixed now.
> >> Many Thanks.
> >>=20
> >> $ scripts/checkpatch.pl
> >> 0001-tcm_qla2xxx-Add-SCSI-command-jammer-discard-capabili.patch
> >> WARNING: added, moved or deleted file(s), does MAINTAINERS need up=
dating?
> >> #12:
> >> new file mode 100644
> >>=20
> >> total: 0 errors, 1 warnings, 91 lines checked
> >>=20
> >> 0001-tcm_qla2xxx-Add-SCSI-command-jammer-discard-capabili.patch ha=
s style
> >> problems, please review.
> >>=20
> >> NOTE: If any of the errors are false positives, please report
> >>       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> >>=20
> >>=20
> >>=20
> >> Tested by: Laurence Oberman <loberman@redhat.com>
> >> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> >> ---
> >>  Documentation/scsi/tcm_qla2xxx.txt |   22 ++++++++++++++++++++++
> >>  drivers/scsi/qla2xxx/Kconfig       |    9 +++++++++
> >>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
> >>  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    1 +
> >>  4 files changed, 52 insertions(+), 0 deletions(-)
> >>  create mode 100644 Documentation/scsi/tcm_qla2xxx.txt
> >>=20
> >> diff --git a/Documentation/scsi/tcm_qla2xxx.txt
> >> b/Documentation/scsi/tcm_qla2xxx.txt
> >> new file mode 100644
> >> index 0000000..c3a670a
> >> --- /dev/null
> >> +++ b/Documentation/scsi/tcm_qla2xxx.txt
> >> @@ -0,0 +1,22 @@
> >> +tcm_qla2xxx jam_host attribute
> >> +------------------------------
> >> +There is now a new module endpoint atribute called jam_host
> >> +attribute: jam_host: boolean=3D0/1
> >> +This attribute and accompanying code is only included if the
> >> +Kconfig parameter TCM_QLA2XXX_DEBUG is set to Y
> >> +By default this jammer code and functionality is disabled
> >> +
> >> +Use this attribute to control the discarding of SCSI commands to =
a
> >> +selected host.
> >> +This may be useful for testing error handling and simulating slow=
 drain
> >> +and other fabric issues.
> >> +
> >> +Setting a boolean of 1 for the jam_host attribute for a particula=
r host
> >> + will discard the commands for that host.
> >> +Reset back to 0 to stop the jamming.
> >> +
> >> +Enable host 4 to be jammed
> >> +echo 1 >
> >> /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/a=
ttrib/jam_host
> >> +
> >> +Disable jamming on host 4
> >> +echo 0 >
> >> /sys/kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/a=
ttrib/jam_host
> >> diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx/K=
config
> >> index 10aa18b..67c0d5a 100644
> >> --- a/drivers/scsi/qla2xxx/Kconfig
> >> +++ b/drivers/scsi/qla2xxx/Kconfig
> >> @@ -36,3 +36,12 @@ config TCM_QLA2XXX
> >>  	default n
> >>  	---help---
> >>  	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic 24=
xx+
> >>  	series
> >>  	target mode HBAs
> >> +
> >> +if TCM_QLA2XXX
> >> +config TCM_QLA2XXX_DEBUG
> >> +	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ seri=
es
> >> target
> >> mode HBAs"
> >> +	default n
> >> +	---help---
> >> +	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for QLo=
gic
> >> 24xx+
> >> series target mode HBAs
> >> +	This will include code to enable the SCSI command jammer
> >> +endif
> >> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> index 1808a01..948224e 100644
> >> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> @@ -457,6 +457,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_ho=
st_t
> >> *vha,
> >> struct qla_tgt_cmd *cmd,
> >>  	struct se_cmd *se_cmd =3D &cmd->se_cmd;
> >>  	struct se_session *se_sess;
> >>  	struct qla_tgt_sess *sess;
> >> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> +	struct se_portal_group *se_tpg;
> >> +	struct tcm_qla2xxx_tpg *tpg;
> >> +#endif
> >>  	int flags =3D TARGET_SCF_ACK_KREF;
> >> =20
> >>  	if (bidi)
> >> @@ -477,6 +481,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_ho=
st_t
> >> *vha,
> >> struct qla_tgt_cmd *cmd,
> >>  		return -EINVAL;
> >>  	}
> >> =20
> >> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> +	se_tpg =3D se_sess->se_tpg;
> >> +	tpg =3D container_of(se_tpg, struct tcm_qla2xxx_tpg, se_tpg);
> >> +	if (unlikely(tpg->tpg_attrib.jam_host)) {
> >> +		/* return, and dont run target_submit_cmd,discarding command */
> >> +		return 0;
> >> +	}
> >> +#endif
> >> +
> >>  	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
> >>  	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffe=
r[0],
> >>  				cmd->unpacked_lun, data_length, fcp_task_attr,
> >> @@ -844,6 +857,9 @@ DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
> >>  DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
> >>  DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
> >>  DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
> >> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> +DEF_QLA_TPG_ATTRIB(jam_host);
> >> +#endif
> >> =20
> >>  static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[] =
=3D {
> >>  	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
> >> @@ -851,6 +867,9 @@ static struct configfs_attribute
> >> *tcm_qla2xxx_tpg_attrib_attrs[] =3D {
> >>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
> >>  	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
> >>  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
> >> +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> +	&tcm_qla2xxx_tpg_attrib_attr_jam_host,
> >> +#endif
> >>  	NULL,
> >>  };
> >> =20
> >> @@ -1023,6 +1042,7 @@ static struct se_portal_group *tcm_qla2xxx_m=
ake_tpg(
> >>  	tpg->tpg_attrib.demo_mode_write_protect =3D 1;
> >>  	tpg->tpg_attrib.cache_dynamic_acls =3D 1;
> >>  	tpg->tpg_attrib.demo_mode_login_only =3D 1;
> >> +	tpg->tpg_attrib.jam_host =3D 0;
> >> =20
> >>  	ret =3D core_tpg_register(wwn, &tpg->se_tpg, SCSI_PROTOCOL_FCP);
> >>  	if (ret < 0) {
> >> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> index 3bbf4cb..37e026a 100644
> >> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
> >> @@ -34,6 +34,7 @@ struct tcm_qla2xxx_tpg_attrib {
> >>  	int prod_mode_write_protect;
> >>  	int demo_mode_login_only;
> >>  	int fabric_prot_type;
> >> +	int jam_host;
> >>  };
> >> =20
> >>  struct tcm_qla2xxx_tpg {
> >> --
> >> 1.7.1
> >>=20
> >>=20
> >> Laurence Oberman
> >> Principal Software Maintenance Engineer
> >> Red Hat Global Support Services
> >>=20
> >> ----- Original Message -----
> >> From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
> >> To: "Laurence Oberman" <loberman@redhat.com>
> >> Cc: "Himanshu Madhani" <himanshu.madhani@qlogic.com>, "Bart Van As=
sche"
> >> <bart.vanassche@sandisk.com>, "linux-scsi" <linux-scsi@vger.kernel=
=2Eorg>,
> >> "target-devel" <target-devel@vger.kernel.org>, "Quinn Tran"
> >> <quinn.tran@qlogic.com>
> >> Sent: Monday, April 4, 2016 4:54:11 PM
> >> Subject: Re: [PATCH]  tcm_qla2xxx Add SCSI command jammer/discard
> >> capability
> >> to the tcm_qla2xxx module
> >>=20
> >> On Sun, 2016-04-03 at 09:57 -0400, Laurence Oberman wrote:
> >> > Hi Nicholas
> >> >=20
> >> > Apologies for the top posting, that was in my haste to correct t=
he prior
> >> > patch that had the typo.
> >> > When I investigated the attributes it looked like I would have h=
ad to
> >> > create a store and a check function and call the check function =
each
> >> > time.
> >> > That was my lack of understanding of the functionality.
> >> >=20
> >> > I also looked at your example and in my case I needed a way to s=
et the
> >> > attribute to a number matching the host#.
> >> > When I tested this I was only able to set boolean values of 1 or=
 0 for
> >> > the
> >> > attributes and the definition of
> >> > tcm_qla2xxx_tpg_attrib_##name##_store validates that only boolea=
ns of 1
> >> > or
> >> > 0 are supported.
> >> >=20
> >> > However after your email I then realized using a boolean on the
> >> > endpoints
> >> > below will work here.
> >> > Thank you for taking the time to show me, it was very helpful.
> >> >=20
> >> > sys]# find . -name jam_host
> >> > ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:ae/tpgt_1/at=
trib/jam_host
> >> > ./kernel/config/target/qla2xxx/21:00:00:24:ff:27:8f:af/tpgt_1/at=
trib/jam_host
> >> >=20
> >> > I tested this and here are the patches in the format you require=
=2E
> >> > Hopefully this new functionality will be useful for others.
> >> > I am not set for emailing directly from git.
> >> >=20
> >> > Tested by: Laurence Oberman <loberman@redhat.com>
> >> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> >> > ---
> >> >  drivers/scsi/qla2xxx/Kconfig       |   11 +++++++++++
> >> >  drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
> >> >  drivers/scsi/qla2xxx/tcm_qla2xxx.h |    1 +
> >> >  3 files changed, 32 insertions(+), 0 deletions(-)
> >> >=20
> >> > diff --git a/drivers/scsi/qla2xxx/Kconfig b/drivers/scsi/qla2xxx=
/Kconfig
> >> > index 10aa18b..5110fab 100644
> >> > --- a/drivers/scsi/qla2xxx/Kconfig
> >> > +++ b/drivers/scsi/qla2xxx/Kconfig
> >> > @@ -36,3 +36,14 @@ config TCM_QLA2XXX
> >> >  	default n
> >> >  	---help---
> >> >  	Say Y here to enable the TCM_QLA2XXX fabric module for QLogic =
24xx+
> >> >  	series target mode HBAs
> >> > +
> >> > +config TCM_QLA2XXX_DEBUG
> >> > +	bool "TCM_QLA2XXX fabric module DEBUG mode for QLogic 24xx+ se=
ries
> >> > target
> >> > mode HBAs"
> >> > +	depends on SCSI_QLA_FC && TARGET_CORE
> >> > +	depends on LIBFC
> >> > +	select BTREE
> >> > +	default n
> >> > +	---help---
> >> > +	Say Y here to enable the TCM_QLA2XXX fabric module DEBUG for Q=
Logic
> >> > 24xx+
> >> > series target mode HBAs
> >> > +	This will include code to enable the SCSI command jammer
> >> > +
> >>=20
> >> Instead of duplicating the 'depends' here for TCM_QLA2XXX, just do=
 a:
> >>=20
> >> if TCM_QLA2XXX
> >>=20
> >> config TCM_QLA2XXX_DEBUG
> >> ...
> >> ...
> >>=20
> >> endif
> >>=20
> >> > diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> > b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> > index 1808a01..411a450 100644
> >> > --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> > +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> >> > @@ -457,6 +457,10 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_=
host_t
> >> > *vha, struct qla_tgt_cmd *cmd,
> >> >  	struct se_cmd *se_cmd =3D &cmd->se_cmd;
> >> >  	struct se_session *se_sess;
> >> >  	struct qla_tgt_sess *sess;
> >> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> > +        struct se_portal_group *se_tpg;
> >> > +        struct tcm_qla2xxx_tpg *tpg;
> >> > +#endif
> >>=20
> >> Whitespace instead of TAB here.
> >>=20
> >> >  	int flags =3D TARGET_SCF_ACK_KREF;
> >> > =20
> >> >  	if (bidi)
> >> > @@ -476,6 +480,15 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_=
host_t
> >> > *vha, struct qla_tgt_cmd *cmd,
> >> >  		pr_err("Unable to locate active struct se_session\n");
> >> >  		return -EINVAL;
> >> >  	}
> >> > +
> >> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> > +	se_tpg =3D se_sess->se_tpg;
> >> > +	tpg =3D container_of(se_tpg,struct tcm_qla2xxx_tpg, se_tpg);
> >> > + 	if (unlikely(tpg->tpg_attrib.jam_host)) {
> >> > + 		/* return, and dont run target_submit_cmd,discarding command=
 */
> >> > +                return 0;
> >> > +	}
> >> > +#endif
> >>=20
> >> Whitespace instead of TABs here too.
> >>=20
> >> > =20
> >> >  	cmd->vha->tgt_counters.qla_core_sbt_cmd++;
> >> >  	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buf=
fer[0],
> >> > @@ -844,6 +857,9 @@ DEF_QLA_TPG_ATTRIB(cache_dynamic_acls);
> >> >  DEF_QLA_TPG_ATTRIB(demo_mode_write_protect);
> >> >  DEF_QLA_TPG_ATTRIB(prod_mode_write_protect);
> >> >  DEF_QLA_TPG_ATTRIB(demo_mode_login_only);
> >> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> > +DEF_QLA_TPG_ATTRIB(jam_host);
> >> > +#endif
> >> > =20
> >> >  static struct configfs_attribute *tcm_qla2xxx_tpg_attrib_attrs[=
] =3D {
> >> >  	&tcm_qla2xxx_tpg_attrib_attr_generate_node_acls,
> >> > @@ -851,6 +867,9 @@ static struct configfs_attribute
> >> > *tcm_qla2xxx_tpg_attrib_attrs[] =3D {
> >> >  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_write_protect,
> >> >  	&tcm_qla2xxx_tpg_attrib_attr_prod_mode_write_protect,
> >> >  	&tcm_qla2xxx_tpg_attrib_attr_demo_mode_login_only,
> >> > +#ifdef CONFIG_TCM_QLA2XXX_DEBUG
> >> > +        &tcm_qla2xxx_tpg_attrib_attr_jam_host,
> >> > +#endif
> >> >  	NULL,
> >> >  };
> >>=20
> >> Whitespace instead of TABs here too.
> >>=20
> >>=20
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-sc=
si" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-sc=
si" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>=20
> >
> >Hello Himanshu, Quinn
> >
> >Is this patch good now to be taken.
> >
> >Thanks
> >Laurence
> >
>=20
> Looks Good.
>=20
> Acked-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>=20
> >
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=CA=87=DA=99=EF=BF=BD,j=EF=BF=BD=
=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=BF=
=BD=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDj:+v=
=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=BF=BD=DD=
=A2j"=EF=BF=BD=EF=BF=BD
Hi Nicholas,

Can we pull this one in for submission now that its been acked'd by Him=
anshu.
Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
