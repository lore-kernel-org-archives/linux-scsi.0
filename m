From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v2 1/1] [SCSI] enclosure: Handle non-unique element descriptors
Date: Sat, 4 Oct 2014 13:35:15 +0000
Message-ID: <c83e1c6c-34e8-48bb-9c06-1464273fdbe6@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-8202f232-2044-40ca-be7b-747b8ee8c029"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay.collogia.de ([194.8.207.98]:21825 "HELO
	mailrelay.collogia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750850AbaJDNhO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Oct 2014 09:37:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This is a multi-part message in MIME format.

------=_NextPartTM-000-8202f232-2044-40ca-be7b-747b8ee8c029
Content-Type: text/plain

[SCSI] enclosure: Handle non-unique element descriptors

Some SES devices give non-unique Element Descriptors as part of the
Element Descriptor diag page. Since we use these for creating sysfs
entries, they need to be unique. The specification doesn't require
these to be unique.

Eg:
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

Based on http://thread.gmane.org/gmane.linux.scsi/69289. This
version implements James' ideas about the naming convention

v2: unbound loop

Signed-off-by: Markus Stockhausen <stockhausen@collogia.de>
Acked-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 2cf2bbc..dc3130a 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -187,6 +187,7 @@ void enclosure_unregister(struct enclosure_device *edev)
 EXPORT_SYMBOL_GPL(enclosure_unregister);
 
 #define ENCLOSURE_NAME_SIZE	64
+#define COMPONENT_NAME_SIZE	64
 
 static void enclosure_link_name(struct enclosure_component *cdev, char *name)
 {
@@ -246,6 +247,29 @@ static void enclosure_component_release(struct device *dev)
 	put_device(dev->parent);
 }
 
+struct enclosure_component *
+enclosure_component_find_by_name(struct enclosure_device *edev,
+				const char *name)
+{
+	int i;
+	const char *cname;
+	struct enclosure_component *ecomp;
+
+	if (!edev || !name || !name[0])
+		return NULL;
+
+	for (i=0; i<edev->components; i++) {
+		ecomp = &edev->component[i];
+		cname = dev_name(&ecomp->cdev);
+		if (ecomp->number != -1 &&
+		    cname && cname[0] &&
+		    !strcmp(cname, name))
+			return ecomp;
+	}
+
+	return NULL;
+}
+
 static const struct attribute_group *enclosure_component_groups[];
 
 /**
@@ -269,7 +293,8 @@ enclosure_component_register(struct enclosure_device *edev,
 {
 	struct enclosure_component *ecomp;
 	struct device *cdev;
-	int err;
+	int err, i;
+	char newname[COMPONENT_NAME_SIZE];
 
 	if (number >= edev->components)
 		return ERR_PTR(-EINVAL);
@@ -283,9 +308,20 @@ enclosure_component_register(struct enclosure_device *edev,
 	ecomp->number = number;
 	cdev = &ecomp->cdev;
 	cdev->parent = get_device(&edev->edev);
-	if (name && name[0])
-		dev_set_name(cdev, "%s", name);
-	else
+
+	if (name && name[0]) {
+		/* Some hardware (e.g. enclosure in RX300 S6) has components
+		 * with non unique names. Registering duplicates in sysfs
+		 * will lead to warnings during bootup. So make the names
+		 * unique by appending consecutive numbers -1, -2, ... */
+		i = 1;
+		snprintf(newname, COMPONENT_NAME_SIZE,
+			 "%s", name);
+		while (enclosure_component_find_by_name (edev, newname))
+			snprintf(newname, COMPONENT_NAME_SIZE,
+				 "%s-%i", name, i++);
+		dev_set_name(cdev, "%s", newname);
+	} else
 		dev_set_name(cdev, "%u", number);
 
 	cdev->release = enclosure_component_release;

------=_NextPartTM-000-8202f232-2044-40ca-be7b-747b8ee8c029
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-8202f232-2044-40ca-be7b-747b8ee8c029--
