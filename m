From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH 4/7] lpfc 8.1.5 : Fix cleanup code in the lpfc_pci_probe_one()
 error code path
Date: Sun, 16 Apr 2006 19:03:29 -0400
Message-ID: <4442CD41.6010106@emulex.com>
References: <1145116391.3795.3.camel@localhost.localdomain> <20060415164026.GA2939@infradead.org>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33999 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750829AbWDPXD5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Apr 2006 19:03:57 -0400
In-Reply-To: <20060415164026.GA2939@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Ok - so what's going on here is that the pci subsystem treated any
positive (not just zero) return value as success. We returned error codes,
but not negative error codes. Thus, the pci subsystem was calling our
remove function even though we returned an error status in our probe
function.

the updated patch will be posted shortly.

-- james

Christoph Hellwig wrote:
> On Sat, Apr 15, 2006 at 11:53:10AM -0400, James Smart wrote:
>> @@ -1725,9 +1730,14 @@ static void __devexit
>>  lpfc_pci_remove_one(struct pci_dev *pdev)
>>  {
>>  	struct Scsi_Host   *host = pci_get_drvdata(pdev);
>> -	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
>> +	struct lpfc_hba    *phba;
>>  	unsigned long iflag;
>>  
>> +	if (host == NULL)
>> +		return;
>> +
>> +	phba = (struct lpfc_hba *)host->hostdata;
> 
> If this ever happen there's something really badly wrong in lpfc_pci_probe_one,
> so please don't put this check in.
> 
