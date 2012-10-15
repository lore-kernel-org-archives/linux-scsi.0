From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 00/10] scsi: avoid linebreaks in syslog output
Date: Mon, 15 Oct 2012 08:02:17 +0200
Message-ID: <507BA6E9.8020002@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de> <CAMM=eLfLq3sqm4hkiCAqB2m75+1UN+3O0pvYMOES-xHT9PHiwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856Ab2JOGCT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2012 02:02:19 -0400
In-Reply-To: <CAMM=eLfLq3sqm4hkiCAqB2m75+1UN+3O0pvYMOES-xHT9PHiwA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 10/15/2012 02:19 AM, Mike Snitzer wrote:
> On Fri, Oct 12, 2012 at 4:33 AM, Hannes Reinecke <hare@suse.de> wrote=
:
>> This patchset updates the SCSI midlayer to use dev_printk() instead
>> of the simple printk(). The main objective here is to avoid line-bre=
aks
>> in syslog output; with the current state it's nearly impossible to m=
atch
>> the output to the occurring device; under high load even the CDB wil=
l
>> be split off into individual bytes, spread randomly across the lines=
=2E
>> Which makes debugging via scsi_logging_level _really_ hard.
>> In addition we'll be getting the syslog messages nicely prefixed wit=
h
>> the device, which will make userspace logging daemons happy.
>>
>> Before:
>> [  297.300605] sd 2:0:3:2: Send:
>> [  297.300607] 0xffff8802348b0980
>> [  297.300610] sd 2:0:3:2: CDB:
>> [  297.300615] Test Unit Ready: 00 00 00 00 00 00
>> [  297.300747] sd 2:0:3:2: Done:
>> [  297.300750] 0xffff8802348b0980 SUCCESS
>> [  297.300753] sd 2:0:3:2:
>> [  297.300755] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK
>> [  297.300758] sd 2:0:3:2: CDB:
>> [  297.300764] Test Unit Ready: 00 00 00 00 00 00
>> [  297.300766] sd 2:0:3:2:
>> [  297.300769] Sense Key : Unit Attention [current]
>> [  297.300771] Info fld=3D0x0
>> [  297.300772] sd 2:0:3:2:
>> [  297.300776] Add. Sense: Capacity data has changed
>>
>> After:
>> [  636.683556] sd 2:0:3:2: Send: 0xffff88043145eec0
>> [  636.727856] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
>> [  636.785330] sd 2:0:3:2: Done: 0xffff88043145eec0 SUCCESS
>> [  636.838228] sd 2:0:3:2: Result: hostbyte=3DDID_OK driverbyte=3DDR=
IVER_OK
>> [  636.899099] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
>> [  636.955905] sd 2:0:3:2: Sense Key : Unit Attention [current]
>> [  637.069179] sd 2:0:3:2: Add. Sense: Capacity data has changed
>
> I know there are a lot of changes here but shouldn't all this get
> fixed in stable 3.5+?
>

If you ask me, yes, of course.
I can easily post a v2 of the patchset (meanwhile I've got another
patch for st :-), Cc'ing stable with it.

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
