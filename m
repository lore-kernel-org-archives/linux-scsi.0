From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] fc transport: pre-emptively terminate i/o upon	dev_loss_tmo
Date: Wed, 22 Apr 2009 15:20:24 -0400
Message-ID: <49EF6DF8.1010808@emulex.com>
References: <1240423291.27035.3.camel@ogier> <49EF6D85.6060404@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42062 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756567AbZDVTUo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2009 15:20:44 -0400
In-Reply-To: <49EF6D85.6060404@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ralphw@linux.vnet.ibm.com" <ralphw@linux.vnet.ibm.com>, Abhijeet Joglekar <ajoglekar@nuovasystems.com>



Mike Christie wrote:
> James Smart wrote:
>  =20
>> Mike, Ralph,
>>
>> See if this helps. It compiles, but I haven't tested it.
>>
>> This modifies the final deletion steps, after dev_loss_tmo has fired=
,
>> such that we keep a flag indicating we're deleting, and we only clea=
r
>> the flag once the additional steps that we had to perform w/o lock,
>> are complete.  Then, in fc_remote_port_add(), when we fall into the
>> case of using the rports for the bindings, which corresponds to the
>> "open" unlocked code area, we stall and wait for the delete to
>> finish before completing the rest of the add.
>> =EF=BB=BF
>> I'm a little nervous about the delay in fc_remote_port_add, but it
>> should be quick, and our callees should be in a context that it's
>> allowed.
>>
>>    =20
>
> I think we can just revert the patch if you want. I do not think it i=
s=20
> needed for the fnic driver anymore. It was needed because fnic needed=
=20
> the rport port id to be set when terminate_rport_io was called right?=
=20
Correct.
> I=20
> do not think it is needed now, because it looks like the driver will=20
> look that up from another code path now.
>  =20
If this is true - then yes, reverting the patch would be the best optio=
n.

-- james

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
