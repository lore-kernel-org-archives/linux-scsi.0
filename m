From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v4 2/4] Documentation:: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Thu, 21 Nov 2013 09:49:42 -0800
Message-ID: <CAPw-ZTmyUjqcHhcqpjvwY-+xOKSyJh1MwA=KgjdDzmWpPXE3GA@mail.gmail.com>
References: <1385014298-15700-1-git-send-email-lho@apm.com>
	<1385014298-15700-2-git-send-email-lho@apm.com>
	<1385014298-15700-3-git-send-email-lho@apm.com>
	<201311211316.03647.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <201311211316.03647.arnd@arndb.de>
Sender: linux-ide-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Jon Masters <jcm@redhat.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi,

>> +SATA host controller nodes are defined to describe on-chip Serial ATA
>> +controllers. Each SATA controller (pair of ports) have its own node.
>> +
>> +Required properties:
>> +- compatible         : Shall be "apm,xgene-ahci"
>> +- reg                        : First memory resource shall be the AHCI memory
>> +                       resource.
>> +                       Second memory resource shall be the host controller
>> +                       memory resource.
>> +- interrupt-parent   : Interrupt controller
>> +- interrupts         : Interrupt mapping for SATA host controller IRQ
>> +- clocks             : Reference to the clock entry
>> +- phys                       : PHY reference
>> +- phy-names          : Name of the PHY reference. The name should be
>> +                       formed by "sataphy" plus lower case hex for the
>> +                       lower 32-bit PHY CSR address (2nd memory resource)
>
> I've tried to explain this before, but apparently you missed the point:
>
> Any "*-names" property is supposed to be the identifier inside the device you
> are describing, *not* an identifier for what it points to, as that already
> has a name. The idea is that the driver can ask for phy (or clock, irq,
> memory, etc) "foo" here, with foo identifying the functionality in the
> device. If you only have one phy, you probably don't want to name it at
> all. If you imagine a device that was connected to two different phys
> depending on the mode it's used in (e.g. SATA-II vs SATA-6G), you would
> list this as
>
>  - phy-names            : one name per references in the "phys" property.
>                           valid names are "sata-ii" and "sata-6g".
>
> If the generic phy subsystem requires you to name this, I'd suggest either
> changing the phy subsystem to make the name optional, or to just call it
> "serdes", as that is the kind of phy you are connected to.
>
> Does this make more sense to you now?
>
[Loc Ho]
Okay... Got it. I will name it as 'sata-6g'

-Loc
