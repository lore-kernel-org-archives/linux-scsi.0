From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/3] megaraid_sas: Convert to host_lock less w/	interrupts
 disabled internally
Date: Mon, 29 Nov 2010 16:56:18 +0100
Message-ID: <4CF3CD22.2050504@suse.de>
References: <1290928656-31116-1-git-send-email-nab@linux-iscsi.org> <1290929339.6216.188.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140Ab0K2PxJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2010 10:53:09 -0500
In-Reply-To: <1290929339.6216.188.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bo Yang <Bo.Yang@lsi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@suse.de>

On 11/28/2010 08:28 AM, Nicholas A. Bellinger wrote:
> On Sat, 2010-11-27 at 23:17 -0800, Nicholas A. Bellinger wrote:
>> From: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> Greetings Hannes, Bo and Co,
>>
>> This series converts megaraid_sas to run in modern host_lock-less mo=
de
>> for >=3D .37-rc3+ with interrupts disabled internally around megasas=
_instance->hba_lock.
>> This series is currently living in lio-core-2.6.git/lock_less-LLDs-f=
or-38-v2,
>> and is intended for .38 mainline code.
>>
>> The first patch adds a handful of missing barriers around instance->=
fw_outstanding
>> usage w/ atomic_add() and atomic_dec().
>>
>> The second converts instance->issuepend_done to an atomic_t, along w=
ith
>> the necessary assignments in order to run w/ Scsi_Host->host_lock, a=
nd
>> without instance->hba_lock.
>>
>> The third patch does the actual conversion, and adds a __megasas_get=
_cmd()
>> usased by megasas_queue_command() w/ instance->hba_lock, along with
>> being held for megasas_build_ldio() and megasas_build_dcdb() in orde=
r
>> to locate the proper frame for struct megasas_cmd.  This is really t=
he
>> one major change in order to get host_lock-less to function with int=
errupts
>> disabled around hba_lock.
>>
>> So far this has been tested with Hannes's QEMU 8708EM2 HBA emulation=
 with
>> TCM_Loop backends using SG_IO from KVM host in a paired Host/Guest .=
37-rc3
>> environment.  This has not been tested on real silicon yet, but I be=
lieve
>> this series should be working there as well.
>>
>=20
> And quick screenshot running in KVM Host TCM_Loop host_lock-less mode
> into KVM Guest megaraid_sas host_lock-less mode w/ small block LTP
> disktest.
>=20
> http://www.linux-iscsi.org/index.php/File:TCM_loop-megasas-37-rc3.png
>=20
> Just a FYI, with scsi-generic <-> TCM_Loop everything appears to be
> stable for both small and large block size tests.
>=20
Oh, good. I did some initial tests with megaraid_sas & host_lock
disabled, but ran into the problems you mentioned.
And have been too lazy to pursue this problem further.
Thanks for your work; I'll give it a spin and see if the throughput
speed has increased.

Thanks for the patches.

Btw, I've found one issue wrt Windows7 booting; now we're not
crashing anymore. But we're not exactly progressing, either;
apparently Win7 fails to notify that we've finished the commands.
Continue debugging.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
