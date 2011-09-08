From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Re: [PATCH v2 15/18] fcoe: Move common functions to
 fcoe_transport library
Date: Thu, 8 Sep 2011 07:41:37 -0700
Message-ID: <4E68D421.5060809@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
 <1312504732-4572-16-git-send-email-bprakash@broadcom.com>
 <4E68A2CD.5020804@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2913 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab1IHOlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2011 10:41:55 -0400
In-Reply-To: <4E68A2CD.5020804@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, "robert.w.love@intel.com" <robert.w.love@intel.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 9/8/2011 4:11 AM, Mike Christie wrote:
> On 08/04/2011 07:38 PM, Bhanu Prakash Gollapudi wrote:
>>   /**
>> - * fcoe_get_wwn() - Get the world wide name from LLD if it supports=
 it
>> - * @netdev: the associated net device
>> - * @wwn: the output WWN
>> - * @type: the type of WWN (WWPN or WWNN)
>> - *
>> - * Returns: 0 for success
>> - */
>> -static int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int ty=
pe)
>> -{
>> -	const struct net_device_ops *ops =3D netdev->netdev_ops;
>> -
>> -	if (ops->ndo_fcoe_get_wwn)
>> -		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
>> -	return -EINVAL;
>> -}
>> -
>> -/**
>
>
>
>> +/**
>> + * fcoe_get_wwn() - Get the world wide name from LLD if it supports=
 it
>> + * @netdev: the associated net device
>> + * @wwn: the output WWN
>> + * @type: the type of WWN (WWPN or WWNN)
>> + *
>> + * Returns: 0 for success
>> + */
>> +int fcoe_get_wwn(struct net_device *netdev, u64 *wwn, int type)
>> +{
>> +	const struct net_device_ops *ops =3D netdev->netdev_ops;
>> +
>> +	if (ops->ndo_fcoe_get_wwn)
>> +		return ops->ndo_fcoe_get_wwn(netdev, wwn, type);
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL_GPL(fcoe_get_wwn);
>> +
>>
>
> I got a report that this is going to be a problem because the fcoe op=
s
> like ndo_fcoe_get_wwn are defined when CONFIG_FCOE is set. That is se=
t
> for fcoe.ko. If you move functions calling those callouts to libfcoe
> then it is possible CONFIG_FCOE is not set (if you were just using
> bnx2fc.ko and not using fcoe.ko for example), and the build fails lik=
e this:
>
>
> drivers/scsi/fcoe/fcoe_transport.c: In function =91fcoe_get_wwn=92:
> drivers/scsi/fcoe/fcoe_transport.c:152: error: =91const struct
> net_device_ops=92 has no member named =91ndo_fcoe_get_wwn=92
> drivers/scsi/fcoe/fcoe_transport.c:153: error: =91const struct
> net_device_ops=92 has no member named =91ndo_fcoe_get_wwn=92
> make[3]: *** [drivers/scsi/fcoe/fcoe_transport.o] Error 1
>
>
> Do we need some ifdefs in libfcoe around the ops use or should there =
be
> some sort of lower level transport module callouts (or whatever modul=
es
> like bnxfc and fcoe are called) that libfcoe calls into so those driv=
ers
> can call into something like the netdev callouts if they use them?
>
Mike, This change has already been submitted and applied to net-next=20
tree, as the change is in netdevice.h. The flags and ndo_fcoe_get_wwn=20
are now moved under CONFIG_LIBFCOE.

http://patchwork.ozlabs.org/patch/111838/


Thanks,
Bhanu


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
