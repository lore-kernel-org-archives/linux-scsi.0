From: "Rajat  Jain, Noida" <rajatj@noida.hcltech.com>
Subject: Hot-plugging Support in kernel 2.6.8 ??
Date: Sat, 5 Feb 2005 07:05:39 +0530
Message-ID: <267988DEACEC5A4D86D5FCD780313FBB041F8310@exch-03.noida.hcltech.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-newbie-owner@vger.kernel.org
To: Linux-scsi@vger.kernel.org, linux-newbie@vger.kernel.org, linux-india-help@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org


Hi list,
 
I'm new to Linux / SCSI so please help me out on this one.

I'm investigating the "Hot Plugging" support in SCSI subsystem of linux
kernel 2.6.8. I am working at the LLD level. I went through the "Hot Plug
Initialisation Model" in Doumentation/scsi/scsi_mid_low_api.txt (which is
not up to date) and code and concluded that :

1) In case a new HBA is Hot plugged, the LLD needs to call
scsi_host_alloc(), scsi_add_host(), scsi_scan_host().
2) In case an existing HBA is Hot UN-plugged, the LLD needs to call
scsi_remove_host(), scsi_host_put().
3) In case a new SCSi device is hot plugged / Un plugged to an existing HBA,
LLD needs to call scsi_add_device() / scsi_remove_device() respectively.

But what is not clear to me is that how exacly I (as an LLD writer) come to
know that a new device has been detected? So where do I put these calls? Are
there any specific functions in LLD that are called when a new device / HBA
is added??  The documentation says this:

"Typically a driver will respond to a sysfs probe() callback that indicates
an HBA has been detected". 

What does this mean? Simply put, I have my own function that I want to be
called when ever a new SCSI device is detected on an existing HBA. How do I
do that? Or how can I achieve this functionality?

Any pointers are welcome. 
 

Thanks & regards,

Rajat Jain 
HCL Technologies, 
A-11, Sector 16, Noida-201301. 
Ph: +91-120-2510701/702/813 Extn.3019 
rajatj@noida.hcltech.com 
http://www.hcltech.com/
	"...one of the main causes of the fall of the Roman Empire was that,
lacking zero, they had no way to indicate successful termination of their C
programs."
	Robert Firth 

-
To unsubscribe from this list: send the line "unsubscribe linux-newbie" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at http://www.linux-learn.org/faqs
