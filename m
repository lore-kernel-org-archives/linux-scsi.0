From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Best approach for using sg_ses to control locate/fault leds?
Date: Wed, 09 Jun 2010 15:35:30 -0700
Message-ID: <4C101732.9010304@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpauth13.prod.mesa1.secureserver.net ([64.202.165.37]:42804
	"HELO smtpauth13.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753905Ab0FIWmM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2010 18:42:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Greetings,

     I am using sg_ses to poll a SAS JBOD for locate and fault led 
status and light leds if needed. So far the only method I can figure out 
how to accomplish this is by reading page 2 of the SES management device 
in the jbod chassis, dumping the raw hex output to a file, setting the 
select and RQST IDENT or RQST FAULT bits and sending back the entire 480 
bytes with modified bits.

Turn locate led on:
sg_ses --page=0x2 /dev/sg18 -f --raw > /tmp/out
...twittle bits in /tmp/out with editor of choice...
sg_ses --control --page=2 -d - /dev/sg18 < /tmp/out

     Is there a utility, a '--element=' arg or another method by which 
only the four bytes of the element control diag page can be sent instead 
of all 480 bytes?

--Jeff

-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810   f: 858-412-3845
m: 619-204-9061

4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

