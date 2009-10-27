From: James Smart <James.Smart@Emulex.Com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Tue, 27 Oct 2009 15:44:52 -0400
Message-ID: <4AE74DB4.4030908@emulex.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com> <20091021152437.GA19717@schmichrtp.de.ibm.com> <4ADF37D5.5090507@emulex.com> <20091023075839.GC5930@schmichrtp.de.ibm.com> <4AE1C2A7.3040508@emulex.com> <20091027165943.GA21795@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:54741 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693AbZJ0Toy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2009 15:44:54 -0400
In-Reply-To: <20091027165943.GA21795@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Thanks Christof.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


Christof Schmitt wrote:
> On Fri, Oct 23, 2009 at 10:50:15AM -0400, James Smart wrote:
>> Christof Schmitt wrote:
>>> It looks to me like this is required to prevent offline SCSI devices
>>> in this case. Should this code be in a FC transport helper function
>>> rather than being duplicated in each FC LLD?
>> That would make sense....
>>
>> -- james s
> 
> Here is a patch for this. It is only compile tested on x86, but the
> code move is fairly trivial.
> 
> Christof
> ---
> scsi_transport_fc: Introduce helper function for blocking scsi_eh
> 
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Move the duplicated code from FC LLDs to SCSI FC transport class.
> 
> Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
> ---
>  drivers/scsi/fnic/fnic_scsi.c    |   20 ++------------------
>  drivers/scsi/lpfc/lpfc_scsi.c    |   30 ++++--------------------------
>  drivers/scsi/qla2xxx/qla_os.c    |   25 ++++---------------------
>  drivers/scsi/scsi_transport_fc.c |   26 ++++++++++++++++++++++++++
>  include/scsi/scsi_transport_fc.h |    1 +
>  5 files changed, 37 insertions(+), 65 deletions(-)
> 
