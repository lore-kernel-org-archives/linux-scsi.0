From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan'
 module parameter
Date: Wed, 2 Mar 2016 13:59:39 +0800
Message-ID: <56D6814B.9020302@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <1456127462-2817-2-git-send-email-hare@suse.de>
 <20160301131252.GA7786@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbcCBF7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 00:59:53 -0500
In-Reply-To: <20160301131252.GA7786@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org

On 03/01/2016 09:12 PM, Christoph Hellwig wrote:
> On Mon, Feb 22, 2016 at 08:51:01AM +0100, Hannes Reinecke wrote:
>>  /*
>> + * disable_target_scan: Disable target scan per default
>> + *   useful on larger installations where only a small
>> + *   number of LUNs are required for booting.
>> + */
>> +static bool fc_disable_target_scan;
>> +
>> +module_param_named(disable_target_scan, fc_disable_target_scan,
>> +		   bool, S_IRUGO|S_IWUSR);
>> +MODULE_PARM_DESC(disable_target_scan,
>> +		 "Disable target scan on remote ports (default=3D0)");
>> +
>> +/*
>>   * Redefine so that we can have same named attributes in the
>>   * sdev/starget/host objects.
>>   */
>> @@ -3272,10 +3284,14 @@ fc_scsi_scan_rport(struct work_struct *work)
>>  	struct Scsi_Host *shost =3D rport_to_shost(rport);
>>  	struct fc_internal *i =3D to_fc_internal(shost->transportt);
>>  	unsigned long flags;
>> +	bool disable_target_scan;
>> +
>> +	disable_target_scan =3D fc_disable_target_scan ?
>> +		fc_disable_target_scan : i->f->disable_target_scan;
>> =20
>>  	if ((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) &&
>>  	    (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>> -	    !(i->f->disable_target_scan)) {
>> +	    !disable_target_scan) {
>=20
> Wouldn't this be simpler by just writing:
>=20
> if ((rport->port_state =3D=3D FC_PORTSTATE_ONLINE) &&
>     (rport->roles & FC_PORT_ROLE_FCP_TARGET) &&
>     !i->f->disable_target_scan && !disable_target_scan) {
>=20
> that being said I don't understand why we need this in the FC transpo=
rt
> class.  What is so special about FC that we do it here and not global=
ly?
>=20
Main reasons being that
a) it's most commonly on FC where you end up having thousands of LUNs;
SAS domains are of finite size and you'd need to string quite a few SAS
expanders together to achieve a similar setup. And iSCSI is ... well.
b) FC already has the required infrastructure in place where you easily
can suppress a target scan, making the patch really trivial.

So rather than trying to come up with a generic solution and an overly
complicated patch I opted for the simpler version :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
