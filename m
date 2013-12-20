From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/2] target_core_spc: bounds check for spc_emulate_inquiry()
Date: Fri, 20 Dec 2013 07:47:25 +0100
Message-ID: <52B3E7FD.9030504@suse.de>
References: <1387460172-27396-1-git-send-email-hare@suse.de>	 <1387460172-27396-3-git-send-email-hare@suse.de> <1387491087.5567.62.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317Ab3LTGr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Dec 2013 01:47:26 -0500
In-Reply-To: <1387491087.5567.62.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/19/2013 11:11 PM, Nicholas A. Bellinger wrote:
> On Thu, 2013-12-19 at 14:36 +0100, Hannes Reinecke wrote:
>> Instead of using a static buffer for inquiry data we should
>> rather use the command-provided buffer and implement proper
>> bounds checking when writing to it.
>> Inquiry is by no means time-critical ...
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_spc.c     | 391 +++++++++++++++++++++---=
-----------
>>  include/target/target_core_backend.h |   2 +-
>>  2 files changed, 235 insertions(+), 158 deletions(-)
>>
>=20
> Mmmmm, so this used to be the case once upon a time, and was changed =
to
> the current local buffer copy + possible truncate for simplicities sa=
ke.
>=20
> I still favor the copy to an oversized local buffer vs. adding explic=
it
> size checks to every possible assignment..
>=20
> How about changing the local buffer to heap memory instead, and bumpi=
ng
> SE_INQUIRY_BUF to 1024 bytes..?
>=20
Ok. But then we should have a quick check at the start

if (cmd->data_length > SE_INQUIRY_BUF)
  len =3D cmd->data_length
else
  len =3D SE_INQUIRY_BUF

to catch oversized requests.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
