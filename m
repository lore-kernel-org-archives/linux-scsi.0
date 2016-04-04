From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: Re: [PATCH v12 8/9] add TC G210 platform driver
Date: Mon, 4 Apr 2016 11:48:23 +0100
Message-ID: <57024677.2060009@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
 <aa4c31ba977bc5c07f5706f12c4d9fbb1bb0ec36.1459448160.git.jpinto@synopsys.com>
 <20160404051546.GE17806@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:46378 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbcDDKsb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 06:48:31 -0400
In-Reply-To: <20160404051546.GE17806@rob-hp-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robh@kernel.org>, Joao Pinto <Joao.Pinto@synopsys.com>
Cc: tomas.winkler@intel.com, vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com


Hi Rob,

On 4/4/2016 6:15 AM, Rob Herring wrote:
> On Thu, Mar 31, 2016 at 07:57:21PM +0100, Joao Pinto wrote:
>> This patch adds a glue platform driver for the Synopsys G210 Test Chip.
>>
>> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
>> ---

[snip]

>> +
>> +Required properties:
>> +- compatible	: compatible list must contain the PHY type & version:
>> +			"snps, g210-tc-6.00-20bit"
>> +			"snps, g210-tc-6.00-40bit"
> Remove the space              ^
> 
>> +		  complemented with the Controller IP version:
>> +			"snps, dwc-ufshcd-1.40a"
> 
> ditto

Ok, will do that!

> 
> Combining the phy and controller compatible strings is a bit strange. 
> Generally, they would be separate nodes using the common phy binding.
> 

Correct, but in this case is just the compatibility string is just to tell the
dw ufs host that it has a 40-bit or a 20-bit test chip connected. The Test chip
is initialized by a unipro command sequence and there is no more ops related to it.

>> +		  complemented with the JEDEC version:
>> +			"jedec,ufs-1.1"
>> +			"jedec,ufs-2.0"
>> +
>> +- reg		: <registers mapping>
>> +- interrupts	: <interrupt mapping for UFS host controller IRQ>
>> +
>> +Example for a setup using a 1.40a DWC Controller with a 6.00 G210 40-bit TC:
>> +	dwc_ufs@d0000000 {
> 
> No underscores please.

Ok, will update it.

> 
>> +		compatible = "snps, g210-tc-6.00-40bit",
>> +			     "snps, dwc-ufshcd-1.40a",
>> +			     "jedec,ufs-2.0";
>> +		reg = < 0xd0000000 0x10000 >;
>> +		interrupts = < 24 >;
>> +	};
> 

Will send a v13 with these tweaks.

Thanks.

