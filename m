From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] mptsas: support link error attributes
Date: Tue, 11 Oct 2005 17:31:09 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C046A765F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35309 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932360AbVJKXbW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Oct 2005 19:31:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tuesday, October 11, 2005 12:36 PM, Christoph Hellwig wrote: 
> 
> The patch I sent out (and attached again) applies perfect against
> 2.6.14-rc4.  The comment is there in 2.6.14-rc4 aswell.
> 

My mistake.  I upgraded email clients today, and it
was the culprit in malforming the patch. Sorry.


> -static void mptsas_print_phy_pg0(SasPhyPage0_t *pg0)
> +static int mptsas_get_linkerrors(struct sas_phy *phy)
>  {
> -	__le64 sas_address;
> +	MPT_ADAPTER *ioc = phy_to_ioc(phy);
> +	ConfigExtendedPageHeader_t hdr;
> +	CONFIGPARMS cfg;
> +	SasPhyPage1_t *buffer;
> +	dma_addr_t dma_handle;
> +	int error;
>  
> -	memcpy(&sas_address, &pg0->SASAddress, sizeof(__le64));
> +	hdr.PageVersion = MPI_SASPHY1_PAGEVERSION;
> +	hdr.ExtPageLength = 0;
> +	hdr.PageNumber = 1 /* page number 1*/;
> +	hdr.Reserved1 = 0;
> +	hdr.Reserved2 = 0;
> +	hdr.PageType = MPI_CONFIG_PAGETYPE_EXTENDED;
> +	hdr.ExtPageType = MPI_CONFIG_EXTPAGETYPE_SAS_PHY;
>  
> -	printk("---- SAS PHY PAGE 0 ------------\n");
> -	printk("Attached Device Handle=0x%X\n",
> -			le16_to_cpu(pg0->AttachedDevHandle));
> -	printk("SAS Address=0x%llX\n",
> -			(unsigned long long)le64_to_cpu(sas_address));
> -	printk("Attached PHY Identifier=0x%X\n", 
> pg0->AttachedPhyIdentifier);
> -	printk("Attached Device Info=0x%X\n",
> -			le32_to_cpu(pg0->AttachedDeviceInfo));
> -	printk("Programmed Link Rate=0x%X\n", pg0->ProgrammedLinkRate);
> -	printk("Change Count=0x%X\n", pg0->ChangeCount);
> -	printk("PHY Info=0x%X\n", le32_to_cpu(pg0->PhyInfo));
> -	printk("\n");
> -}
> +	cfg.cfghdr.ehdr = &hdr;
> +	cfg.physAddr = -1;
> +	cfg.pageAddr = phy->identify.phy_identifier;
> +	cfg.action = MPI_CONFIG_ACTION_PAGE_HEADER;
> +	cfg.dir = 0;    /* read */
> +	cfg.timeout = 10;
>  

The "phy->identify.phy_identifier" being passed is incorrect
for this config page. 

I noticed that in /sys/class/sas_phy/phy-0:x, that all the
phy_identifier attributes is all zero for all the phys. 
It should be the same as x.  

The problem appears that in sas device page 0, it 
returns zero for the PhyNum field.   For sas 
device page 0, the first devices are all for the 
direct attached(or identity) phys. So if you have a 
four port sas card, the first four are the direct 
attached phys.  Any other devices are actual sas 
end devices, such as disks.  For the direct 
attached(or identity) phys, it always returns zero. 
In CSMI get_phy_info, I hard code those identity 
phys from 0 to max expected phys(which you get
from sas_io_unit_page 0).  It appears we may need
to do the same here, perhaps in mptsas_probe_hba_phys
after device page 0 is read.
Also the expander pages seem to have the same issue.
I'm investigating.

Eric
