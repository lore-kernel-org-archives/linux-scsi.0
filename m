From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: RE: How to find which (physical) SCSI HBA corresponds to which ho
	st n	umber?
Date: Fri, 1 Apr 2005 09:53:20 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB065A083E@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ngate.noida.hcltech.com ([202.54.110.230]:1993 "EHLO
	ngate.noida.hcltech.com") by vger.kernel.org with ESMTP
	id S262616AbVDAEYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 23:24:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>, "Rajat Jain, Noida" <rajatj@noida.hcltech.com>
Cc: linux-scsi@vger.kernel.org


Hi Bryan,

Thanks for the reply. I got my queries solved. 

> 
> As with other SCSI numbering (LUNs, Linux device numbers), 
> you normally don't try to prescribe which numbers go to which 
> equipment, but rather discover afterward -- 
> proc/scsi/hba_name/host_number.  The identifying information 
> is dependent on the particular HBA type and driver, and 
> sometimes doesn't exist.
> 

This proc entry is made AFTER the device is registered with SCSI mid-level
driver (scsi_mod). 

I have a system with "N" number of similar HBAs attached. So basically what
that means is that after I add a SCSI device to one of the HBAs, the only
option I have left with me is following

For n = 0 to N
Do
	echo "scsi add-single-device n 0 ID 0" > /proc/scsi/scsi
done
 
i.e. trial and method that tries to scan for the particular target on ALL
the HBAs???

Rajat

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bryan Henderson
> Sent: Friday, April 01, 2005 4:57 AM
> To: Rajat Jain, Noida
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: How to find which (physical) SCSI HBA 
> corresponds to which host n umber?
> 
> By default, Linux assigns host numbers to HBAs somewhat 
> arbitrarily.  In practice, it's fairly predictable as long as 
> you don't change anything -- Linux assigns them sequentially 
> starting at zero in the order in which it discovers them, 
> which is controlled first by the order in which Linux 
> initializes the corresponding HBA driver.
> 
> But you can control it a little.  The 'scsihosts' module 
> parameter of the SCSI midlayer driver scsi_mod reserves host 
> numbers for specific HBA drivers.  It looks like 
> "scsihosts=aic7xxx,aic7xxx,qla1280".  That means to reserve 
> host numbers 0 and 1 for the aic7xxx driver and 2 for qla1280. 
> The two reserved for aic7xxx are assigned in the order that 
> the aic7xxx driver registers them, which is ordinarily the 
> order in which the aic7xxx driver detects them.  I don't 
> think there's usually a way to control that, but it should be 
> repeatable as long as the hardware configuration stays the 
> same.  But it's generally not good to rely on the hardware 
> configuration staying the same.  Some day, one card will be 
> broken or temporarily removed, and that will change the host 
> number of the other one.
> 
> As with other SCSI numbering (LUNs, Linux device numbers), 
> you normally don't try to prescribe which numbers go to which 
> equipment, but rather discover afterward -- 
> proc/scsi/hba_name/host_number.  The identifying information 
> is dependent on the particular HBA type and driver, and 
> sometimes doesn't exist.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 


Disclaimer: 

This message and any attachment(s) contained here are information that is
confidential,proprietary to HCL Technologies and its customers, privileged
or otherwise protected by law.The information is solely intended for the
individual or the entity it is addressed to. If you are not the intended
recipient of this message, you are not authorized to read, forward,
print,retain, copy or disseminate this message or any part of it. If you
have received this e-mail in error, please notify the sender immediately by
return e-mail and delete it from your computer.


