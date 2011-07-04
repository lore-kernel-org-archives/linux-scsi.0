From: Ankit Jain <jankit@suse.de>
Subject: Re: [PATCH] ses: Handle non-unique element descriptors
Date: Tue, 05 Jul 2011 04:29:43 +0530
Message-ID: <4E1245DF.5000403@suse.de>
References: <4E11D946.4050307@suse.de> <1309793724.2606.19.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab1GDW5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2011 18:57:53 -0400
In-Reply-To: <1309793724.2606.19.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

On 07/04/2011 09:05 PM, James Bottomley wrote:
> On Mon, 2011-07-04 at 20:46 +0530, Ankit Jain wrote:
>> Some SES devices give non-unique Element Descriptors as part of the
>> Element Descriptor diag page. Since we use these for creating sysfs
>> entries, they need to be unique.
>>
>> Eg:
>> $ sg_ses -p 7 /dev/sg0
>>   FTS CORP  TXS6_SAS20BPX12   0500
>>     enclosure services device
>> Element descriptor In diagnostic page:
>>   generation code: 0x0
>>   element descriptor by type list
>>     Element type: Array device, subenclosure id: 0
>>       Overall descriptor: ArrayDevicesInSubEnclsr0
>>       Element 1 descriptor: ArrayDevice00
>>       Element 2 descriptor: ArrayDevice01
>>       Element 3 descriptor: ArrayDevice02
>>       Element 4 descriptor: ArrayDevice03
>>       Element 5 descriptor: ArrayDevice03
>>       Element 6 descriptor: ArrayDevice03
>>       Element 7 descriptor: ArrayDevice03
>>       Element 8 descriptor: ArrayDevice03
>>       Element 9 descriptor: ArrayDevice03
>>       Element 10 descriptor: ArrayDevice03
>>       Element 11 descriptor: ArrayDevice03
>>       Element 12 descriptor: ArrayDevice03
> 
> What is the external visible labelling of this topology?  It's
> completely weird that the enclosure would burn in non-unique names
> unless there's some reason for it.

I'm not sure what you mean by "external visible labelling". The system has a
SAS expanded backplane. I don't have access to the hardware now, but p7 looked
like this:

$ sg_ses -p 7 /dev/sg0
  FTS CORP  TXS6_SAS20BPX12   0500
    enclosure services device
Element descriptor In diagnostic page:
  generation code: 0x0
  element descriptor by type list
    Element type: Array device, subenclosure id: 0
      Overall descriptor: ArrayDevicesInSubEnclsr0
      Element 1 descriptor: ArrayDevice00
      Element 2 descriptor: ArrayDevice01
      Element 3 descriptor: ArrayDevice02
      Element 4 descriptor: ArrayDevice03
      Element 5 descriptor: ArrayDevice03
      Element 6 descriptor: ArrayDevice03
      Element 7 descriptor: ArrayDevice03
      Element 8 descriptor: ArrayDevice03
      Element 9 descriptor: ArrayDevice03
      Element 10 descriptor: ArrayDevice03
      Element 11 descriptor: ArrayDevice03
      Element 12 descriptor: ArrayDevice03
    Element type: SAS connector, subenclosure id: 0
      Overall descriptor: ConnectorsInSubEnclsr0
      Element 1 descriptor: Connector04
      Element 2 descriptor: Connector05
      Element 3 descriptor: Connector06
      Element 4 descriptor: Connector07
      Element 5 descriptor: Connector00
      Element 6 descriptor: Connector01
      Element 7 descriptor: Connector02
      Element 8 descriptor: Connector03
      Element 9 descriptor: Connector08
      Element 10 descriptor: Connector09
      Element 11 descriptor: Connector10
      Element 12 descriptor: Connector11
    Element type: Temperature sense, subenclosure id: 0
      Overall descriptor: TempSensorsInSubEnclsr0
      Element 1 descriptor: TempSense01
      Element 2 descriptor: TempSense02
      Element 3 descriptor: TempSense03
    Element type: Voltage sensor, subenclosure id: 0
      Overall descriptor: VoltageSensorsInSubEnclsr0
      Element 1 descriptor: VoltageSense01
      Element 2 descriptor: VoltageSense02
      Element 3 descriptor: VoltageSense03
      Element 4 descriptor: VoltageSense04
    Element type: Current sensor, subenclosure id: 0
      Overall descriptor: CurrentSensorsInSubEnclsr0
      Element 1 descriptor: CurrentSense01
    Element type: Enclosure, subenclosure id: 0
      Overall descriptor: EnclosureElementInSubEnclsr0
      Element 1 descriptor: EnclosureElement01
    Element type: SAS expander, subenclosure id: 0
      Overall descriptor: SAS Expander
      Element 1 descriptor: Expander0

AFAICS, the spec doesn't seem to say that the names have to be unique.
But, now that I think about it a bit, possibly some of the "array device
slots" might have been vacant, and so descriptors could have been repeated.
This could probably be checked with the status page.
But then I'm not sure, whether sysfs entries should or shouldn't be created
for some cases (eg. status code!=OK).

>> -				if (create)
>> +				if (create) {
>> +					if (enclosure_component_find_by_name(edev, name))
>> +						/* name is not unique, already used
>> +						 * set to NULL, so that enclosure_component_register
>> +						 * will assign us a new one */
>> +						name = NULL;
> 
> This just assigns a random name ... if we actually have one, we should
> probably just make it unique.

Agreed. Would something like (below) be acceptable? I'll post the patch
separately, if it is:

---
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 00e5fca..f4b53fd 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -239,6 +239,23 @@ static void enclosure_component_release(struct device *dev)
 	put_device(dev->parent);
 }
 
+static struct enclosure_component *
+enclosure_component_find_by_name(struct enclosure_device *edev,
+				const char *name)
+{
+	int i;
+	if (!edev || !name || !name[0])
+		return NULL;
+
+	for (i=0; i<edev->components; i++) {
+		struct enclosure_component *ecomp = &edev->component[i];
+		if (ecomp->number != -1 && !strcmp(dev_name(&ecomp->cdev), name))
+			return ecomp;
+	}
+
+	return NULL;
+}
+
 static const struct attribute_group *enclosure_groups[];
 
 /**
@@ -276,9 +293,13 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name && name[0])
-		dev_set_name(cdev, "%s", name);
-	else
+
+	if (name && name[0]) {
+		if (enclosure_component_find_by_name (edev, name))
+			dev_set_name(cdev, "%s_%u", name, number);
+		else
+			dev_set_name(cdev, "%s", name);
+	} else
 		dev_set_name(cdev, "%u", number);
 
 	cdev->release = enclosure_component_release;

-- 
Ankit Jain
SUSE Labs
